#!/bin/bash

set -Eeuo pipefail

##################### INCLUDES
declare BASH_SRC_db="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
declare UTILS_DIR="${BASH_SRC_db}/../utils"

source ${UTILS_DIR}/docker_utils.sh

##################### GLOBAL VARIABLES
declare DOCKER_CONTEXT="$(du_get_dockerfiles_dir)"
declare BASE_IMAGE="$(du_get_base_docker_image_name)"
declare DOCKER_BUILDER_IMAGE_NAME="$(du_get_builder_docker_image_name)"

declare PRESERVE_INTERMEDIATE
declare CURRENT_IMAGE_NAME

declare IMAGE_TO_BUILD
declare C_IMAGE="c"
declare BUILDER_IMAGE="builder"

##################### FUNCTIONS
function usage() {
	cat << EOM
Usage: $0 [PARAMS]

PARAMS:
	--nvim-c			Build Neovim customized for C languaje
	--preserve-builder-image	Do not delete intermediate docker image (Gain speed on future builds). By default intermediate image will be deleted
	-h, --help			Display this menu and exit
	-d, --debug			Enable debug mode

EXAMPLE:
	$(basename $0) --nvim-c --preserver-builder-image
	$(basename $0) --nvim-c
EOM

	exit 1
}

function docker_image_build() {
	local image_name="${1}"
	local dockerfile="${2}"
	local base_image="${3}"

	docker build -t ${image_name} -f ${dockerfile}  \
		--build-arg BASE_IMAGE=${base_image} \
		${DOCKER_CONTEXT}

	return $?
}

function docker_builder_image_build() {
	local docker_builder_image_name="${DOCKER_BUILDER_IMAGE_NAME}"
	local dockerfile_builder="$(du_get_builder_dockerfile)"

	docker_image_build ${docker_builder_image_name} ${dockerfile_builder} \
		${BASE_IMAGE}

	return $?
}

function docker_c_image_build() {
	local docker_c_image_name="${1}"
	local dockerfile_c="$(du_get_c_dockerfile)"

	docker_image_build ${docker_c_image_name} ${dockerfile_c} \
		${BASE_IMAGE}

	return $?
}

function docker_post_image_build() {
	local docker_post_image_name="${1}"
	local dockerfile="$(du_get_post_dockerfile)"

	docker_image_build ${docker_post_image_name} ${dockerfile} \
		${docker_post_image_name}

	return $?
}

##################### FETCH ARGS
while [[ "$#" -gt 0 ]]; do
	case "${1:-}" in
		-h | --help) usage ;;
		-d | --debug) set -x ;;
		--nvim-c) IMAGE_TO_BUILD="${C_IMAGE}" ;;
		--nvim-builder)
			IMAGE_TO_BUILD="${BUILDER_IMAGE}"
			PRESERVE_INTERMEDIATE="y" ;;
		--preserve-builder-image) PRESERVE_INTERMEDIATE="y" ;;
		*)
			echo "ERROR: Unknown option \"${1:-}\""
			usage
			;;
	esac
	shift
done

if [ -z "${IMAGE_TO_BUILD:-}" ]; then
	echo "ERROR: No image to be built specified"
	usage
fi

##################### MAIN
docker_builder_image_build

if [ "${IMAGE_TO_BUILD}" != "${BUILDER_IMAGE}" ]; then
	case "${IMAGE_TO_BUILD}" in
		"${C_IMAGE}") 
			CURRENT_IMAGE_NAME="$(du_get_c_docker_image_name)"
			docker_c_image_build ${CURRENT_IMAGE_NAME}
			;;
		*) 
			echo "ERROR: Unkown Nvim docker image to build"
			usage
			;;

	esac

	docker_post_image_build ${CURRENT_IMAGE_NAME}
fi

[ -z "${PERSERVE_INTERMEDIATE:-}" ] &&
	docker rmi -f ${DOCKER_BUILDER_IMAGE_NAME}

exit $?
