;(function () {

const NO_COMMENTS = `
    <p class="page-comments-none">No comments for now.</p>
`

function getReactions(repo, id) {
    return Promise.resolve(null)
}

const getMarkdownConverter = (function () {
    const converter = new showdown.Converter({
        simplifiedAutoLink: true,
        excludeTrailingPunctuationsFromURLs: true,
        tables: true,
        strikethrough: true,
        ghMentions: true,
        ghMentionsLink: true,
        ghCodeBlocks: true,
        openLinksInNewWindow: true,
        taskLists: true,
    })
    return function (markdown) {
        return converter.makeHtml(markdown)
    }
})

const pageComments = document.querySelector('#page-comments')

function addNewCommentLink(repo, id) {
    const p = document.createElement('p')
    p.textContent = 'Share your thoughts! '
    const link = document.createElement('a')
    link.href = `https://github.com/${repo}/issues/${id}#new_comment_field`
    link.target = '_blank'
    link.rel = 'noopener'
    link.textContent = 'Add a comment'
    p.appendChild(link)
    pageComments.parentElement.insertBefore(p, pageComments)
}

function getComments(repo, id) {
    const url = `https://api.github.com/repos/${repo}/issues/${id}/comments`
    return fetch(url)
        .then(response => response.json())
        .then(comments => comments.map(comment => ({
            body_html: markdownToHTML(comment.body),
            user: { login: comment.user.login, avatar_url: comment.user.avatar_url },
        })))
}

function getCommentElementFrom(comment) {
    return `
    <article class="page-comment">
        <a class="page-comment-author" href="https://github.com/${comment.user.login}" target="_blank">
            <img src="${comment.user.avatar_url}" alt="Avatar of ${comment.user.login}"
                class="page-comment-author-avatar"><!--
            --><p class="page-comment-author-name">${comment.user.login}</p>
        </a>
        <div class="page-comment-content">${comment.body_html}</div>
    </article>
    `
}

async function main(repo, id) {
    markdownToHTML = getMarkdownConverter()
    let rcomments = getComments(repo, id)
    let [comments] = [await rcomments]

    if (comments.length === 0) {
        pageComments.innerHTML = NO_COMMENTS
        return
    }
    pageComments.innerHTML = ''
    for (comment of comments) {
        pageComments.innerHTML += getCommentElementFrom(comment)
    }
}

window.loadGithubCommentsFrom = function (repo, id, showdown) {
    pageComments.innerHTML = '<p class="page-comments-loading">Loading comments...</p>'
    addNewCommentLink(repo, id)
    const script = document.createElement('script')
    script.src = showdown
    script.onload = () => {
        main(repo, id)
    }
    document.body.appendChild(script)
}

})()
