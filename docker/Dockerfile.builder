ARG BASE_IMAGE="debian"
FROM ${BASE_IMAGE}

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
		unzip tar build-essential cmake git curl ca-certificates && \
	update-ca-certificates

RUN cd $NVIM_SRC && \
	make CMAKE_BUILD_TYPE=ReWithDebInfo && \
	make install && \
	chmod 777 \
		$CONFIG_NVIM \
		$HOME

# TODO: que parte es la que especifica que instalo C tools
RUN	nvim --headless +'autocmd User PackerComplete quitall' +PackerSync +qa && \
	nvim --headless -c 'MasonInstall clangd' -c 'qa' && \
	nvim --headless -c 'TSUpdate' -c 'qa'

