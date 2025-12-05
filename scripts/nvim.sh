#!/bin/bash

set -Eeuo pipefail

################# INCLUDES
declare BASH_SRC_nvc="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
declare UTILS_PATH="${BASH_SRC_nvc}/../utils"

source "${UTILS_PATH}/docker_utils.sh"

################# MAIN
du_run "nvim" "$@"

exit $?

