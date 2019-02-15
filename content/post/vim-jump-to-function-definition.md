---
title: Jump to function definition in vim
slug: vim-jump-to-function-definition
date: 2018-09-28T11:47:21+10:00
tags: [tip, go, vim, fzf]
---

One of the features I miss from Sublime Text is the Goto Anything. In vim, by
default, you have `:e **/bit` and then tab, and it gets annoying pretty
quickly. Thankfully, there's [`fzf`][fzf] (with [`fzf.vim`][fzf.vim]).<!--more-->

But although it provides a fairly long list of commands, it doesn't allow us to
*jump to function definitions* (which is one of the main function of the Goto
Anything).

## `fzf` for the win

There's no question, `fzf` as done a really good job at being easily extensible.
So, using a bit of vimscript, we'll get a nice Go to definition prompt in vim!

With the autoload function `fzf#run`, we are able to give a shell command
that will get a list of options, and it'll display it for us, calling a simple
callback when the user chooses an option.

And `ag` (a *very* fast version of grep) is going to find the all the function
definitions in our project.

For example, for a go project:

```
$ ag --go -s "^func " | tee
main.go:21:func index(w http.ResponseWriter, r *http.Request) {
main.go:44:func initAPI(r *mux.Router) {
main.go:50:func main() {
resp/resp.go:12:func Message(w http.ResponseWriter, r *http.Request, code int, kind string, format string, a ...interface{}) error {
resp/resp.go:23:func Error(w http.ResponseWriter, r *http.Request, code int, format string, a ...interface{}) error {
resp/resp.go:29:func Success(w http.ResponseWriter, r *http.Request, format string, a ...interface{}) error {
resp/resp.go:37:func InternalError(w http.ResponseWriter, r *http.Request) error {
resp/resp.go:42:func Encode(w http.ResponseWriter, r *http.Request, e interface{}) error {
services/db/db.go:17:func escape(s string) string {
services/db/db.go:35:func (cfg Config) String() string {
...
```

- `--go` searches only through go files
- `-s` makes it case sensitive
- `"^func "` finds all the lines where we're defining a function

And we pipe it through `tee` (which just spits what it's given back out) to see
what `ag` outputs when it's writing to a pipe, and not to a terminal (if it was,
`ag` would add colors and a formatting for humans).

We can't give this to `fzf` though, we need a find a way to 'hide' the ugly
path/line number at the beginning from the user (so that he only searches by
function names).

```
# from this
filename:line:rest
# get this
filename:line searchable
```

where `searchable` is the interesting, clean part of the function signature.

## `awk` to the rescue

I'm not going to go into any details in this post, but with `awk`, we can do
this.

A quick note on awk though: it's extremely powerful (you can do everything
`grep` and `sed` can do), and it's really fast. Use it when you're chaining
commands.

The magic command:

```
awk -F : '{ gsub(/^func | {$/, "", $3); printf "%s:%s %s\n", $1, $2, $3 }'
```

Quick explanation:

- `-F :` says that instead of using spaces as field separators, we're going to
  use colons.
- `gsub(...)` removes (replaces with nothing) the `func` and trailing ` {` parts
  in the third field. This makes the function signature clean and user-friendly.
- `printf` prints `$1:$2 $3` where `$1` is the first field, `$2` is the second
  field, etc...

This gives us a list of formatted lines like this:

```
filename:line signature
```

Now, we can give this to `fzf`, and tell it to display only from the second
field and on (using the `--with-nth` option). And, remember, this one uses
spaces as a field separator.  Therefore, it'll only print the function's
signature.

```
filename:line signature
^-----------^ ^-------^
|             |
|             | this is the second field
|
| this is the first field
```


#### The callback

Now, this is just vimscript.

```vim
let g:fzf_default_action = {
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-x': 'split',
	\ 'ctrl-v': 'vsplit'}

" returns the user action dict if it exists, otherwise, the default one
function! s:fzf_action()
	if exists('g:fzf_action')
		return g:fzf_action
	else
		return {
		\ 'ctrl-v': 'tab split',
		\ 'ctrl-x': 'split',
		\ 'ctrl-t': 'vsplit'}
	endif
endfunction

" the callback that is called with one array of length 2:
" args = [ action, line ]
" where the action is the keystroke that the user pressed to select the
" line (ctrl+x, ctrl+v, etc). If he just pressed enter, it's an empty string.
" And the second argument line is the line he selected.
" The array is empty (length 0) if the user cancelled
function! s:fzf_open_file(args)
	" the user pressed ctrl-c, and cancelled
	if len(a:args) == 0
		return
	endif
	let [action, line] = a:args
	" The line is like this: path/to/filename.go:line ...
	" we want the filename, and the line.
	let [filename; rest] = split(line, ":")
	let [line; rest] = split(join(rest), " ")

	" the get(...) get's the action to run, depending on what the user pressed
	" the format is "action +line filename". This automatically jumps to the
	" right line
	exec get(s:fzf_action(), action, 'edit')." +".line." ".filename
endfunction

function! FzfJumpDef(lang) abort
	if a:lang == 'go'
		" gets all the lines starting with 'func ' in .go files
		let l:command = 'ag --go -s "^func " '
		" formats the output
		" seperator is : (not space)
		let l:command .= '| awk -F : '
		let l:command .= "'{ "
		" removes the func and the trailling in the third field {
		let l:command .= "gsub(/ {$/, \"\", $3);"
		" prints $1:$2 $3
		let l:command .= 'printf "%s:%s %s\n", $1, $2, $3'
		let l:command .= " }'"
		let l:prefix_length = 1
	else
		throw "Lang ".lang." unknown"
	endif
	" l:command is the command that will fetch all the lines
	" the option --with-nth=2.. hides the first field from the user, but is
	" still given to the callback function
	" so, here, we hide the filename and line.
	" the --expect bit allows the user to press ctrl+t to open in a new tab for
	" example (defined by g:fzf_action)
	" the --nth option allows text to be displayed, but not selected. We use
	" this to show the "func ".
	echom l:command
	call fzf#run(fzf#wrap({'source': l:command,
	\ 'options': '--with-nth=2.. --expect='.join(keys(s:fzf_action()), ',').
		\' --nth='.l:prefix_length.'..',
	\ 'sink*': funcref('s:fzf_open_file')}))
endfunction

```

So, if you paste this in your `.vimrc`, you'll be able to call the function like
this:

```
:call FzfJumpDef('go')
```

And it'll open the "browser" and you'll be able to jump to function definition.

Of course, typing this is every time a pain, so I'd recommend setting a shortcut
for every go file that triggers this function, as [explained in this
post][ftplugin].  Spoiler:

```vim
" ~/.vim/ftplugin/go.vim
nnoremap <buffer> M :call FzfJumpDef('go')<CR>
```

And press <kbd>shift+m</kbd> to open the prompt.

Enjoy :smile:

[fzf]: https://github.com/junegunn/fzf
[fzf.vim]: https://github.com/junegunn/fzf.vim
[ftplugin]: /post/vim-filetype-specific-settings
