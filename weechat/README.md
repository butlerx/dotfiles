# weechat

Deployed to `~/.weechat` as a whole directory, so weechat writes its runtime
state back into this repository. The noisy parts are gitignored:

- `weechat/logs/` — chat logs
- `weechat/script/plugins.xml.gz` — the script repository index

`*.conf` files are tracked, which means weechat rewrites them on exit and they
show up as modifications. Commit the ones you meant to change and check the rest
out again.
