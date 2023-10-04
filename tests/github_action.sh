#!/bin/bash
# working dir: repo root

# Set the environment variables
report_path="./coverage"
tmp_path=$(mktemp -d /tmp/omt-manager-XXXXXX)

# get the repo dir
script_dir="$(dirname "$(readlink -f "$0")")"
repo_dir="$(dirname "$script_dir")"

# check if pwd is repo root
current_dir="$(pwd)"
if [[ "$current_dir" != "$repo_dir" ]]; then
    echo "Please run this script in the repo root"
    exit 1
fi

# check if `act` exists
if ! command -v act &>/dev/null; then
    echo "act not installed"
    exit 1
fi

# Make sure the report directory exists
if [[ -d "$report_path" ]]; then
    rm -rf "$report_path"
fi
mkdir -p "$report_path"

# Run the act command
act --artifact-server-path "$tmp_path" -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:runner-latest

# Unzip the coverage report
unzip "$tmp_path/1/coverage-report/coverage-report.zip" -d "$report_path"

# Remove the temporary directory
rm -rf "$tmp_path"
