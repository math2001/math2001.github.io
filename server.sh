if [[ $@ == *--drafts* ]]; then
    hugo server --disableLiveReload --buildDrafts &
else
    hugo server --disableLiveReload &
fi
export HUGO_PID=$!
browser-sync start --proxy "localhost:1313" --files "**/static" --staticFiles "**/static" --no-notify &
export BROWSER_SYNC_PID=$!
