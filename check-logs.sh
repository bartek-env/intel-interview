#!/usr/bin/env bash
# Counts ERROR lines in all .log files under a directory (default: .)
# and fails (exit 1) if any are found.
set -euo pipefail

directory="${1:-.}"

if [[ ! -d "$directory" ]]; then
    echo "Error: '$directory' is not a directory" >&2
    exit 2
fi

# grep exits 1 when it finds no matches, and with pipefail that would abort the
# script. The `|| true` neutralises that so "no matches" simply counts as 0.
# find only runs grep when it finds at least one .log file, so an empty
# directory is safe too. -h drops filename prefixes, -s hides unreadable-file noise.
errorCount=$(
    { find "$directory" -type f -name "*.log" -exec grep -hs "ERROR" {} + || true; } | wc -l
)
errorCount=$((errorCount))   # normalise whitespace from wc on some platforms

echo "Number of errors: $errorCount"

if (( errorCount > 0 )); then
    exit 1
fi

echo "Done"
exit 0
