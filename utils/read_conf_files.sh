#!/bin/bash

set -Eeuo pipefail

####################### INCLUDES
declare BASH_SRC_rcf="$(dirname "${BASH_SOURCE[0]}")"
declare CONF_rcf_DIR="${BASH_SRC_rcf}/../conf"

####################### GLOBAL VARIABLES
declare ROOT_REPO_DIR="$(readlink -f ${BASH_SRC_du}/..)"

####################### COMMON FUNCTIONS
function urcf_get_variable() {
	local path_conf_files="${1}"
	local variable_name="${2}"

	echo "$(cat ${path_conf_files} | grep -E "^${variable_name}=" | cut -d '=' -f 2 | xargs)"
}

######################## docker.conf
declare DOCKER_CONF="${CONF_rcf_DIR}/docker.conf"

function urcf_get_dockerfiles_dir() {
    urcf_get_variable "${DOCKER_CONF}" "DOCKERFILES_DIR"
}

function urcf_get_builder_dockerfile() {
    urcf_get_variable "${DOCKER_CONF}" "DOCKERFILE_BUILDER"
}

function urcf_get_c_dockerfile() {
    urcf_get_variable "${DOCKER_CONF}" "DOCKERFILE_C"
}

function urcf_get_post_dockerfile() {
    urcf_get_variable "${DOCKER_CONF}" "DOCKERFILE_POST"
}

function urcf_get_docker_base_image() {
    urcf_get_variable "${DOCKER_CONF}" "DOCKER_BASE_IMAGE"
}

function urcf_get_docker_default_tag() {
    urcf_get_variable "${DOCKER_CONF}" "DOCKER_DEFAULT_TAG"
}

function urcf_get_docker_builder_image_name() {
	urcf_get_variable "${DOCKER_CONF}" "DOCKER_BUILDER_IMAGE_NAME"
}

function urcf_get_docker_c_image_name() {
	urcf_get_variable "${DOCKER_CONF}" "DOCKER_C_IMAGE_NAME"
}

