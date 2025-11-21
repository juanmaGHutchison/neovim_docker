#!/usr/bin/env bash

docker run --rm -it \
    -u $(id -u):$(id -g) \
    -v "$(pwd)":/workspace \
    -w /workspace \
    -e XDG_CONFIG_HOME=/root/.config \
    -e XDG_DATA_HOME=/root/.local/share \
    -e XDG_STATE_HOME=/root/.local/state \
    -e XDG_CACHE_HOME=/root/.cache \
    borrar \
    nvim "$@"

