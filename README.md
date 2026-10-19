# Keep Mac Awake

Prevents your Mac from sleeping while Cursor agents or subagents are running.

## What it does

- On `sessionStart` / `subagentStart`: starts `/usr/bin/caffeinate -dims`
- On `subagentStop` / `sessionEnd` / `stop`: releases a refcount and stops `caffeinate` only when nothing is left active
- No-op on non-macOS installs

State lives in `~/.cursor/keep-mac-awake/` (PID + refcount).

## Install

### Local (this machine)

Cursor loads plugins from `~/.cursor/plugins/local/<plugin-name>/`. This repo is already in that layout when developed locally. Restart Cursor (or reload) after install.

### Share with teammates

1. Push this folder to a public GitHub repo.
2. Submit at [cursor.com/marketplace/publish](https://cursor.com/marketplace/publish), **or** add the repo to your team marketplace.
3. Others install from **Customize → Plugins**.

## Requirements

- macOS (uses `caffeinate`)
- Cursor with hooks support

## Notes

- User-level / IDE agents only. Cloud agents do not load local home plugins the same way, and cloud work already continues if the Mac sleeps.
- Safe to leave installed: when idle, no `caffeinate` process remains.

## License

MIT
