#!/bin/bash

set -Eeuo pipefail

####################### INCLUDES
declare BASH_SRC_du="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"

source ${BASH_SRC_du}/read_conf_files.sh

####################### GLOBAL VARIABLES
declare DEFAULT_TAG_NAME="$(urcf_get_docker_default_tag)"
declare DOCKERFILES_DIR="${ROOT_REPO_DIR}/$(urcf_get_dockerfiles_dir)"

####################### FUNCTIONS
function du_get_dockerfiles_dir() {
    echo "${DOCKERFILES_DIR}"
}

function du_get_builder_dockerfile() {
    echo "${DOCKERFILES_DIR}/$(urcf_get_builder_dockerfile)"
}

function du_get_c_dockerfile() {
    echo "${DOCKERFILES_DIR}/$(urcf_get_builder_dockerfile)"
}

function du_get_post_dockerfile() {
    echo "${DOCKERFILES_DIR}/$(urcf_get_post_dockerfile)"
}

function du_get_base_docker_image_name() {
    echo "$(urcf_get_docker_base_image)"
}

function du_get_builder_docker_image_name() {
    echo "$(urcf_get_docker_builder_image_name):${DEFAULT_TAG_NAME}"
}

function du_get_c_docker_image_name() {
    echo "$(urcf_get_docker_c_image_name):${DEFAULT_TAG_NAME}"
}

function du_run_nvim() {
	local docker_image_name="${1}"
	local path_to_open="$(readlink -f ${2:-$(pwd)})"
	local docker_user_home="/root"
	local user_local="${docker_user_home}/.local"

	[ -f "${path_to_open}" ] && path_to_open="$(dirname ${path_to_open})"

	docker run -ti --rm -u $(id -u):$(id -g) \
		-v "${path_to_open}":"${path_to_open}" \
		-w "${path_to_open}" \
		-e XDG_CONFIG_HOME=${docker_user_home}/.config \
		-e XDG_DATA_HOME=${user_local}/share \
		-e XDG_STATE_HOME=${user_local}/state \
		-e XDG_CACHE_HOME=${docker_user_home}/.cache \
		${docker_image_name} nvim "$@"

	return $?
}

