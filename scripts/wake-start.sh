#!/bin/bash
# Keep Mac awake while Cursor agents / subagents are running.
set -u

# Always consume stdin so the hook never hangs.
cat > /dev/null

# No-op on non-macOS (plugin installs everywhere; only mac needs this).
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo '{}'
  exit 0
fi

STATE_DIR="${HOME}/.cursor/keep-mac-awake"
PID_FILE="${STATE_DIR}/caffeinate.pid"
COUNT_FILE="${STATE_DIR}/wake.count"
mkdir -p "$STATE_DIR"

count=0
if [[ -f "$COUNT_FILE" ]]; then
  count=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
fi
[[ "$count" =~ ^[0-9]+$ ]] || count=0
count=$((count + 1))
echo "$count" > "$COUNT_FILE"

need_start=1
if [[ -f "$PID_FILE" ]]; then
  old_pid=$(cat "$PID_FILE" 2>/dev/null || true)
  if [[ -n "${old_pid:-}" ]] && kill -0 "$old_pid" 2>/dev/null; then
    need_start=0
  fi
fi

if [[ "$need_start" -eq 1 ]]; then
  # -d display, -i idle, -m disk, -s system sleep (AC)
  /usr/bin/caffeinate -dims >/dev/null 2>&1 &
  echo $! > "$PID_FILE"
fi

echo '{}'
exit 0
