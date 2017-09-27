if [[ $@ == *--kill* ]]; then
    kill $(jobs -p)
    exit 0
fi

if [[ $@ == *--drafts* ]]; then
    hugo server --disableLiveReload --buildDrafts &
else
    hugo server --disableLiveReload &
fi
browser-sync start --proxy "localhost:1313" --files "**/static" --staticFiles "**/static" --no-notify &
