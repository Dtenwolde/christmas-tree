#!/usr/bin/env bash
# An animated Christmas scene, drawn by DuckDB: the picture is the result of tree.sql, the
# query next to this script, which draws the moment it is asked. This loop asks again and
# again, about fifteen times a second.
#
#   ./tree.sh           as fast as that goes
#   ./tree.sh 0.2       with a pause of 0.2 seconds after every frame
#   ./tree.sh 0 100     a hundred frames, then stop
#   DAY=7 ./tree.sh     as it will be on 7 December (the scene is an Advent calendar:
#                       every day of December adds something; ./advent.sh has the day's trick)
#
# The tree is as big as the window allows and follows it when it is resized. Ctrl-C ends it.

set -u
sql="$(cd "$(dirname "$0")" && pwd)/tree.sql"
pause="${1:-0.02}"
frames="${2:-0}"

command -v duckdb >/dev/null || { echo "tree.sh: duckdb is not on the PATH" >&2; exit 1; }
[ -f "$sql" ] || { echo "tree.sh: tree.sql is not next to this script" >&2; exit 1; }
[ -t 1 ] || { echo "tree.sh: this draws on a terminal. One frame: duckdb -list -noheader -f tree.sql" >&2; exit 1; }
export DUCKDB_AGENT_MODE=0                      # (started by a coding agent, DuckDB 2 would write for the agent)

restore() { printf '\033[?25h\033[?1049l'; }    # the cursor and the screen as they were
trap restore EXIT
trap 'exit 0' INT TERM HUP
printf '\033[?1049h\033[?25l'                   # a screen of our own, and no cursor on it

# One row and one column less than the window: the last line stays empty, for the cursor.
size() { rows=$(( $(tput lines) - 1 )); cols=$(( $(tput cols) - 1 )); }
trap size WINCH                                 # the window was resized
size

wipe=$'s/$/\033[K/'                             # every line also wipes what an earlier frame left behind it
frame=0
while :; do
    # (one thread: for a picture this small that is the fastest, and half the work)
    set="SET threads = 1; SET VARIABLE rows = $rows; SET VARIABLE cols = $cols"
    if [ -n "${DAY:-}" ]; then                  # pretend it is that day of December, at this time of day
        set="$set; SET VARIABLE now = '$(date +%Y)-12-$(printf '%02d' "$DAY") $(date +%H:%M:%S)'"
    fi
    printf '\033[H'                             # from the top, over the frame before
    if (( rows < 22 || cols < 42 )); then
        echo "The scene needs a window of at least 43 x 23 characters."
    else
        duckdb -list -noheader -c "$set" -f "$sql" 2>&1
    fi | sed "$wipe"
    printf '\033[J'                             # and nothing under it
    frame=$(( frame + 1 ))
    (( frames > 0 && frame >= frames )) && break
    sleep "$pause"
done
