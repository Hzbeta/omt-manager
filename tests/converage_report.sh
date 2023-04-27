#!/bin/bash
# working dir: repo root

# get the repo dir
script_dir="$(dirname "$(readlink -f "$0")")"
repo_dir="$(dirname "$script_dir")"

# check if pwd is repo root
current_dir="$(pwd)"
if [[ "$current_dir" != "$repo_dir" ]]; then
    echo "Please run this script in the repo root"
    exit 1
fi

# check if act exists
if ! command -v bashcov &>/dev/null; then
    echo "act not installed"
    exit 1
fi

# make dir
report_path="./coverage"

if [[ -d "$report_path" ]]; then
    rm -rf "$report_path"
fi
mkdir -p "$report_path"

# test files path
folder_path="tests"

# traverse all test_*.sh files
for file in "$folder_path"/test_*.sh; do
    if [ -e "$file" ]; then
        # run test
        echo "--------------"
        echo "running $file"
        echo "--------------"
        if [[ "$1" = "to_text" ]]; then
            bashcov -s -- "$file" >>"$report_path/result.txt"
        else
            bashcov -s -- "$file"
        fi
    fi
done

echo "report generated at $report_path"
echo "please use live-server to view the report"
