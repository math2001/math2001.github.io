.PHONY: server

server: 
	browser-sync start --proxy localhost:1313 --files "static" --staticFiles "static" --no-notify --no-ui &
	hugo server --disableLiveReload -D
