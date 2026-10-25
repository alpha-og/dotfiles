#!/bin/sh
# Starts the Rex config listener (naming + tab history), at most one at a
# time. Called detached from init.lua at every config load/reload.
# If an instance is already running (pid alive), this exits quietly.
# If the pid is stale (listener crashed or server restarted), we take over.

PID_FILE="$HOME/.config/rex/scripts/listener.pid"
SCRIPT="$HOME/.config/rex/scripts/listener.lua"
REX="/Users/athulanoop/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"

old=$(cat "$PID_FILE" 2>/dev/null || true)
if [ -n "$old" ] && kill -0 "$old" 2>/dev/null; then
  exit 0
fi
rm -f "$PID_FILE"
echo $$ > "$PID_FILE"
exec "$REX" do "$SCRIPT" --all
