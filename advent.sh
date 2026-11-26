#!/usr/bin/env bash
# A door of the Advent calendar, in the terminal: a DuckDB trick a day, and what it gives.
# The tricks are the files of advent/, the tables they query are advent/north-pole.sql.
#
#   ./advent.sh         today's door (from 1 to 24 December)
#   ./advent.sh 7       the door of 7 December

set -u
dir="$(cd "$(dirname "$0")" && pwd)/advent"
command -v duckdb >/dev/null || { echo "advent.sh: duckdb is not on the PATH" >&2; exit 1; }
export DUCKDB_AGENT_MODE=0                      # (started by a coding agent, DuckDB 2 would write for the agent)

day="${1:-}"
if [ -z "$day" ]; then
    if [ "$(date +%m)" != 12 ] || [ "$(date +%-d)" -gt 24 ]; then
        echo "The calendar runs from 1 to 24 December. A door by its number: ./advent.sh 7"
        exit 0
    fi
    day="$(date +%-d)"
fi
case "$day" in ''|*[!0-9]*) echo "advent.sh: a day is a number from 1 to 24" >&2; exit 1 ;; esac
trick="$dir/$(printf '%02d' "$day").sql"
[ -f "$trick" ] || { echo "advent.sh: there is no door $day (1 to 24)" >&2; exit 1; }

echo "$day December"
echo
cat "$trick"
echo
duckdb -c ".read '$dir/north-pole.sql'" -f "$trick"
