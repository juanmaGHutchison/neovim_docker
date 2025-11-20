FROM ubuntu:24.04

ARG NVIM_SRC=/tmp
ARG NVIM_REPO_DIR=nvim
ARG USER_DIR=/root
ARG CONFIG_NVIM=$USER_DIR/.config
ARG NVIM_PLUGIN_PATH=$USER_DIR/.local/share/$NVIM_REPO_DIR
ARG PACKER_START=$NVIM_PLUGIN_PATH/site/pack/packer/start

COPY nvim_submodule $NVIM_SRC
COPY $NVIM_REPO_DIR $CONFIG_NVIM/$NVIM_REPO_DIR

COPY packer_submodule $PACKER_START/packer.nvim
COPY telescope_submodule $PACKER_START/telescope.nvim
COPY treesitter_submodule $PACKER_START/nvim-treesitter
COPY harpoon_submodule $PACKER_START/harpoon
COPY undotree_submodule $PACKER_START/undotree
COPY fugitive_submodule $PACKER_START/vim-fugitive
COPY lsp_submodule $PACKER_START/lsp-zero.nvim
COPY plenary_submodule $PACKER_START/plenary.nvim
COPY rose-pine_submodule $PACKER_START/rose-pine
COPY mason_submodule $PACKER_START/mason.nvim
COPY mason-lspconfig_submodule $PACKER_START/mason-lspconfig.nvim
COPY lspconfig_submodule $PACKER_START/nvim-lspconfig
COPY cmp_submodule $PACKER_START/nvim-cmp
COPY cmp_path_submodule $PACKER_START/cmp-path
COPY cmp-lsp_submodule $PACKER_START/cmp-nvim-lsp
COPY luasnip_submodule $PACKER_START/LuaSnip
COPY friendly-snippets_submodule $PACKER_START/friendly-snippets


RUN 	apt update && apt install -y --no-install-recommends \
		unzip tar build-essential cmake git curl ca-certificates ripgrep && \
	update-ca-certificates

RUN 	cd $NVIM_SRC && \
	make CMAKE_BUILD_TYPE=ReWithDebInfo && \
	make install && \
	chmod 775 $CONFIG_NVIM

RUN	nvim --headless +'autocmd User PackerComplete quitall' +PackerSync +qa && \
	nvim --headless -c 'MasonInstall clangd' -c 'qa' && \
	nvim --headless -c 'TSUpdate' -c 'qa'
