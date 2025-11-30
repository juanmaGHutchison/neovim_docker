#!/bin/bash

set -Eeuo pipefail

##################### INCLUDES
declare BASH_SRC_db="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
declare UTILS_DIR="${BASH_SRC_db}/../utils"

source ${UTILS_DIR}/docker_utils.sh

##################### FUNCTIONS
function docker_image_build() {
	local image_name="$(du_get_docker_image_name)"
	local docker_context="$(du_get_dockerfiles_dir)"

	docker build -t ${image_name} ${docker_context}

	return $?
}

##################### MAIN
docker_image_build

exit $?
