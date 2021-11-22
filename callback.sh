#!/usr/bin/env bash

echo "The next one disables a shellcheck directive for unused Vars"
# shellcheck disable=SC2034
DEMO_PATH="/bin/bash"
DEMO_INT=1 # Assuming that this value should be 0, 1 or 2
# shellcheck disable=SC2034
DEMO_ARRAY=( "/random/path" )

echo "Output: ${DEMO_INT} - Complain about the CITAS Protocol working"
