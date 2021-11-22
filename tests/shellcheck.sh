#!/usr/bin/env bash

echo "Executing Shellcheck (http://www.shellcheck.net/)"
if shellcheck sample_script.sh; then
    echo "Shellcheck exited without errors."
fi
