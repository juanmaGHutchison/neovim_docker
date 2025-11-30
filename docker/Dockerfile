#ARG BASE_IMAGE="debian:bookworm-slim"
#FROM ${BASE_IMAGE} AS builder
FROM debian:bookworm-slim AS builder

ARG RESOURCES_DIR=./resources

ARG NVIM_SRC=/tmp
ARG NVIM_REPO_DIR=$RESOURCES_DIR/nvim
ARG USER_DIR=/root
ARG CONFIG_NVIM=$USER_DIR/.config
ARG USER_HOME_LOCAL=$USER_DIR/.local
ARG NVIM_PLUGIN_PATH=$USER_HOME_LOCAL/share/nvim
ARG PACKER_START=$NVIM_PLUGIN_PATH/site/pack/packer/start

ARG RESOURCES_DIR=./resources
ARG SUBMODULES_DIR=$RESOURCES_DIR/submodules

COPY $SUBMODULES_DIR/nvim_submodule $NVIM_SRC
COPY $NVIM_REPO_DIR $CONFIG_NVIM/nvim

COPY $SUBMODULES_DIR/packer_submodule $PACKER_START/packer.nvim
COPY $SUBMODULES_DIR/telescope_submodule $PACKER_START/telescope.nvim
COPY $SUBMODULES_DIR/treesitter_submodule $PACKER_START/nvim-treesitter
COPY $SUBMODULES_DIR/harpoon_submodule $PACKER_START/harpoon
COPY $SUBMODULES_DIR/undotree_submodule $PACKER_START/undotree
COPY $SUBMODULES_DIR/fugitive_submodule $PACKER_START/vim-fugitive
COPY $SUBMODULES_DIR/lsp_submodule $PACKER_START/lsp-zero.nvim
COPY $SUBMODULES_DIR/plenary_submodule $PACKER_START/plenary.nvim
COPY $SUBMODULES_DIR/rose-pine_submodule $PACKER_START/rose-pine
COPY $SUBMODULES_DIR/mason_submodule $PACKER_START/mason.nvim
COPY $SUBMODULES_DIR/mason-lspconfig_submodule $PACKER_START/mason-lspconfig.nvim
COPY $SUBMODULES_DIR/lspconfig_submodule $PACKER_START/nvim-lspconfig
COPY $SUBMODULES_DIR/cmp_submodule $PACKER_START/nvim-cmp
COPY $SUBMODULES_DIR/cmp_path_submodule $PACKER_START/cmp-path
COPY $SUBMODULES_DIR/cmp-lsp_submodule $PACKER_START/cmp-nvim-lsp
COPY $SUBMODULES_DIR/luasnip_submodule $PACKER_START/LuaSnip
COPY $SUBMODULES_DIR/friendly-snippets_submodule $PACKER_START/friendly-snippets
COPY $SUBMODULES_DIR/git-blame_submodule $PACKER_START/git-blame.nvim
COPY $SUBMODULES_DIR/copilot_submodule $PACKER_START/copilot.vim

RUN apt update && apt install -y --no-install-recommends \
		unzip tar build-essential npm cmake git curl ca-certificates && \
	update-ca-certificates

RUN cd $NVIM_SRC && \
	make CMAKE_BUILD_TYPE=ReWithDebInfo && \
	make install && \
	chmod 777 \
		$CONFIG_NVIM \
		$HOME

RUN	nvim --headless +'autocmd User PackerComplete quitall' +PackerSync +qa && \
	nvim --headless -c 'MasonInstall clangd' -c 'qa' && \
	nvim --headless -c 'MasonInstall pyright' -c 'qa' && \
	nvim --headless -c 'TSUpdateSync c cpp python lua bash dockerfile ruby' -c 'qa'

#ARG BASE_IMAGE="debian:bookworm-slim"
#FROM $BASE_IMAGE
FROM node:22-bookworm-slim

ARG NVIM_METADATA=nvim
ARG ROOT_HOME=/root
ARG ROOT_LOCAL=$ROOT_HOME/.local
ARG ROOT_CONFIG=$ROOT_HOME/.config
ARG NVIM_PLUGIN_PATH=$ROOT_LOCAL/share/nvim
ARG USR_LOCAL="/usr/local"

#RUN	curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
#	apt update && \
#	apt install -y --no-install-recommends \
#		ripgrep nodejs curl git xz-utils gcc g++ make
RUN	apt update && \
	apt install -y --no-install-recommends \
		ripgrep curl git xz-utils gcc g++ make

COPY --from=builder ${USR_LOCAL}/bin/nvim ${USR_LOCAL}/bin/nvim
COPY --from=builder ${USR_LOCAL}/share/nvim ${USR_LOCAL}/share/nvim
COPY --from=builder /root/.config/nvim ${ROOT_HOME}/.config/nvim
COPY --from=builder /root/.local ${ROOT_HOME}/.local

RUN	mkdir -p ${ROOT_HOME}/.local/state/nvim/undo && \
	chmod -R 777 ${ROOT_HOME}

CMD ["nvim"]

