---
title: "So vim got slow"
date: 2018-05-21T17:59:22+10:00
tags: [tip, vim, profile, performances]
---

You know that feeling? You press in a key, and you have to wait like 0.5 seconds
to see it appear on screen. You try to run `vim --clean` and everything's back
to "normal".

As you expected, it is caused by a/some plugin(s) and/or you vimrc. Have fun
debugging that. You probably know the bulk force: disable every plugin, and
enable them once at a time to know which one's slow.

If you want my opinion: that's a huge waste of time.

Vim comes with a... **profiler**! That means, you can profiles VimScript code
(which is what plugins and what your vimrc is made out of). So, you can just
profile everything, and see what take a long time to run. Here's how:

You open vim, type in:

```vimscript
:profile start profile.log
:profile func *
:profile file *
```

You do the slow things (it can be just typing, running a function, etc), and
then:

```vimscript
:profile pause
```

And quit (`:qa`)

Now open up `profile.log` (it might be fairly long), and go to the bottom.

It'll look something like this:

```
FUNCTIONS SORTED ON SELF TIME¬
count  total (s)   self (s)  function¬
 6231   2.111606   1.448172  FoldFunctions()¬
 6231              0.623322  NextNonBlankLine()¬
    4              0.122261  GetPythonIndent()¬
  149              0.060445  <SNR>19_Highlight_Matching_Pair()¬
 1996              0.040112  IndentLevel()¬
    1   0.112088   0.012412  <SNR>14_open()¬
    1              0.007353  ale#autocmd#InitAuGroups()¬
    1   0.011920   0.004668  <SNR>11_LoadFTPlugin()¬
    1   1.147117   0.003546  <SNR>14_execute()¬
    1   0.005964   0.002463  <SNR>8_SynSet()¬
   14              0.002194  AutoPairsSpace()¬
    1   0.002895   0.001956  AutoPairsInit()¬
    1   1.262952   0.001449  fzf#run()¬
    1   0.011455   0.001114  FileTypeSetup()¬
    1   0.002369   0.001108  fzf#wrap()¬
    9              0.000939  AutoPairsMap()¬
    1   0.001655   0.000910  <SNR>12_LoadIndent()¬
    1   0.002176   0.000697  <SNR>56_DisablePostamble()¬
   12              0.000553  <SNR>14_fzf_call()¬
    1   0.112732   0.000545  <SNR>14_common_sink()¬
```

And now, you should see something that sorts functions based on how long they
took. You can now determine from which plugin/script that was (if you're not
sure, a big fat `grep functionname -R` in your `.vim` directory should tell
you), and you'll know which plugins slowing you down!

Have fun!

#### Details

If you want, you can of course go into a bit more details and see which
statements were slow in each function by scrolling back up in the `profile.log`
file ;)

#### Nice little commands

Put that in your `.vimrc` ;)

```vimscript
command! ProfileMe :profile start profile.log <bar> profile func * <bar> profile file *
command! ProfileStop :profile pause
```
