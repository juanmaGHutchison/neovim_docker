#!/bin/bash

set -Eeuo pipefail

####################### INCLUDES
declare BASH_SRC_du="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"

source ${BASH_SRC_du}/read_conf_files.sh

function du_get_docker_image_name() {
	echo "$(urcf_get_docker_image_name)"
}
