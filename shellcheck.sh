#!/bin/bash

SCRIPTDIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)"
GITROOT="$(readlink -f "${SCRIPTDIR}/../")"

main(){
(
cd "${GITROOT}"
find ./* \
  \( -iname '*.bash' -or -iname '*.sh' \) \
  -exec shellcheck "$@" {} +
)
}

# set -e 
# CITAS method of checking for Bash errors

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
# Bash Strict Mode
set -eu -o pipefail

# set -x
main "$@"
fi

# Taking into account there's no branch flipping
