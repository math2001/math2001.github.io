hugo server --disableLiveReload &
cd themes/fasty
browser-sync start --proxy 'localhost:1313' --files 'static' --ss 'static'
