#!/bin/bash

set -Eeuo pipefail

####################### INCLUDES
declare BASH_SRC_rcf="$(dirname "${BASH_SOURCE[0]}")"
declare CONF_rcf_DIR="${BASH_SRC_rcf}/../conf"

####################### COMMON FUNCTIONS
function urcf_get_variable() {
	local path_conf_files="${1}"
	local variable_name="${2}"

	echo "$(cat ${path_conf_files} | grep -E "^${variable_name}=" | cut -d '=' -f 2 | xargs)"
}

######################## docker.conf
declare DOCKER_CONF="${CONF_rcf_DIR}/docker.conf"

function urcf_get_docker_image_name() {
	urcf_get_variable "${DOCKER_CONF}" "DOCKER_IMAGE_NAME"
}

