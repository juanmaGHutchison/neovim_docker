#!/bin/bash

set -Eeuo pipefail

################# INCLUDES
declare BASH_SRC_nv="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
declare UTILS_PATH="${BASH_SRC_nv}/../utils"

source "${UTILS_PATH}/docker_utils.sh"

################# GLOBAL VARIABLES
declare DOCKER_IMAGE_NAME="$(du_get_docker_image_name)"
declare CURR_PATH="$(readlink -f ${1:-$(pwd)})"

[ -f "${CURR_PATH}" ] && CURR_PATH="$(dirname ${CURR_PATH})"

################# MAIN
docker run --rm -ti \
    -u $(id -u):$(id -g) \
    -v "${CURR_PATH}":"${CURR_PATH}" \
    -w "${CURR_PATH}" \
    -e XDG_CONFIG_HOME=/root/.config \
    -e XDG_DATA_HOME=/root/.local/share \
    -e XDG_STATE_HOME=/root/.local/state \
    -e XDG_CACHE_HOME=/root/.cache \
    ${DOCKER_IMAGE_NAME} \
    nvim "$@"

exit $?

