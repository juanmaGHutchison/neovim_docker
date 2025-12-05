#!/bin/bash 

set -Eeuo pipefail

####################### INCLUDES
declare BASH_SRC_du="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
declare CONF_REPO="${BASH_SRC_du}/../conf"

source "${BASH_SRC_du}/read_conf_files.sh"

####################### FUNCTIONS
function du_get_dockerfiles_dir() {
    echo "${ROOT_REPO_DIR}/$(urcf_get_dockerfiles_dir)"
}

function du_get_docker_image_name() {
    local default_tag_name="$(urcf_get_docker_default_tag)"
    echo "$(urcf_get_docker_builder_image_name):${default_tag_name}"
}

function du_get_undodir_host_volume() {
    echo "${CONF_REPO}/$(urcf_get_undodir_host)" 
}

function du_run() {
	local cmd="${1}"
	local path_to_open="$(readlink -f "${2:-$(pwd)}")"
	local docker_user_home="/root"
	local user_local="${docker_user_home}/.local"
	local undo_dir_host="$(du_get_undodir_host_volume)"
	local path_mnt="${path_to_open}"
    local enable_x11="$(urcf_use_x11_clipboard)"
    local x11_docker_opts

	[ -f "${path_mnt}" ] && path_mnt="$(dirname "${path_mnt}")"
    if [ "${enable_x11}" == "yes" ]; then
	    local x11_tmp="/tmp/.X11-unix"
        xhost +local:docker

        x11_docker_opts="-v ${x11_tmp}:${x11_tmp} -e DISPLAY=${DISPLAY}"
    fi

	docker run -ti --rm -u "$(id -u):$(id -g)" \
		-v "${path_mnt}":"${path_mnt}" \
		-v "${undo_dir_host}":/root/.local/state/nvim/undo \
		-w "${path_mnt}" \
        ${x11_docker_opts:-} \
		-e HOME=${docker_user_home} \
		-e XDG_CONFIG_HOME=${docker_user_home}/.config \
		-e XDG_DATA_HOME=${user_local}/share \
		-e XDG_STATE_HOME=${user_local}/state \
		-e XDG_CACHE_HOME=${docker_user_home}/.cache \
		"$(du_get_docker_image_name)" "${cmd}" "${path_to_open}"

	return $?
}

