#!/bin/bash

set -Eeuo pipefail

################# INCLUDES
declare BASH_SRC_nvc="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
declare UTILS_PATH="${BASH_SRC_nvc}/../utils"

source "${UTILS_PATH}/docker_utils.sh"

################# GLOBAL VARIABLES
declare DOCKER_IMAGE_NAME="$(du_get_c_docker_image_name)"

################# MAIN
du_run_nvim ${DOCKER_IMAGE_NAME} "$@"

exit $?

