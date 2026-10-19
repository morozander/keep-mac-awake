#!/bin/bash
# Release one wake ref. Stop caffeinate only when nothing is still active.
set -u

cat > /dev/null

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
if [[ "$count" -gt 0 ]]; then
  count=$((count - 1))
fi
echo "$count" > "$COUNT_FILE"

if [[ "$count" -eq 0 ]]; then
  if [[ -f "$PID_FILE" ]]; then
    old_pid=$(cat "$PID_FILE" 2>/dev/null || true)
    if [[ -n "${old_pid:-}" ]] && kill -0 "$old_pid" 2>/dev/null; then
      kill "$old_pid" 2>/dev/null || true
    fi
    rm -f "$PID_FILE"
  fi
fi

echo '{}'
exit 0
