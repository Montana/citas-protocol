#!/usr/bin/env bash

echo "Executing Bashate (https://github.com/openstack-dev/bashate)"
if bashate sample_script.sh; then
    echo "Bashate exited without errors."
fi
