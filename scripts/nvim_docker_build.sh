#!/bin/bash

set -Eeuo pipefail

##################### INCLUDES
declare BASH_SRC_db="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
declare UTILS_DIR="${BASH_SRC_db}/../utils"

source ${UTILS_DIR}/docker_utils.sh

##################### GLOBAL VARIABLES
declare DOCKER_IMAGE_NAME="$(du_get_docker_image_name)"

##################### MAIN
docker build -t ${DOCKER_IMAGE_NAME} $BASH_SRC_db/..

exit $?
