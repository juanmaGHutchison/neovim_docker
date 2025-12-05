# Dockerized Neovim Setup

This repository provides a portable Docker-based Neovim setup with custom configurations, plugins, and shortcuts pre-installed. The setup allows users to run Neovim with your preferred environment without requiring local installation of Neovim or plugins.  

## Features

- Pre-configured Neovim with essential plugins for LSP, completion, Treesitter, Telescope, and more.  
- Launcher scripts to easily run Neovim inside Docker from any path.  
- Portable and reproducible environment for development.  

---

## Installation

### 1. Prepare Git Submodules
Before building the Docker image, ensure all submodules are downloaded:
```bash
git submodule update --init --recursive
```

### 2. Build the Docker Image

Use the provided Docker build script to generate the Neovim image:

```bash
cd $PATH_TO_REPOSITORY/scripts
./nvim_docker_build.sh
```

### 3. Install Launcher Scripts

To make Neovim accessible system-wide, create symbolic links to the provided scripts:
```bash
cd /usr/local/bin
ln -s $PATH_TO_REPOSITORY/scripts/nvim.sh dnvim
```

It is possible too make the same with the Docker image builder script (optional)
```bash
cd /usr/local/bin
ln -s $PATH_TO_REPOSITORY/scripts/nvim_docker_build.sh dnvim-build-image
```

After this, you can run Neovim simply with:
```bash
dnvim
```

## Usage

Open any directory as workspace:

```bash
dnvim /path/to/project
```

All plugins, LSP servers, and configurations will be loaded automatically.


## Neovim Plugins

This section lists all the custom keyboard shortcuts configured in this Neovim setup.  
The configuration is fully integrated with the Dockerized environment and includes support for:

- LSP (Language Server Protocol) features for code navigation, diagnostics, and refactoring.
- Autocompletion via `nvim-cmp`.
- File navigation with Telescope.
- Project and file management with Harpoon.
- Undo history visualization with UndoTree.
- Git integration via Fugitive.

All shortcuts are designed to improve efficiency while editing code and navigating projects.  
Use these shortcuts directly in the Dockerized Neovim environment or from your host if using the provided launcher scripts.

***NOTE:***
- ***`<leader>` is mapped to `Space`.***
- ***`<C-..>` is `Ctrl` keycap.***
- ***`<A-..>` is `Alt` keycap.***

### LSP & Completion Shortcuts
| Mode | Shortcut | Action |
|------|---------|--------|
| Normal | **`gd`** | Go to definition |
| Normal | **`K`** | Show hover information |
| Normal | **`<leader>vws`** | Search workspace symbols |
| Normal | **`<leader>vca`** | Trigger code action |
| Normal | **`<leader>vrr`** | Show references |
| Normal | **`<leader>vrn`** | Rename symbol |
| Normal | **`<C-h>`** | Show signature help |
| Normal | **`<leader>vd`** | Show diagnostics in floating window |
| Normal | **`[d`** | Go to next diagnostic |
| Normal | **`]d`** | Go to previous diagnostic |
| Insert | **`<C-p>`** | Select previous completion item |
| Insert | **`<C-n>`** | Select next completion item |
| Insert | **`<C-y>`** | Confirm selected completion item |
| Insert | **`<C-Space>`** | Trigger completion menu |

### Git Integration (Fugitive)

| Mode | Shortcut        | Action                         |
|------|----------------|--------------------------------|
| Normal | `<leader>gs`  | Open Git status (`:Git`)       |

**Description:**  
These shortcuts leverage [vim-fugitive](https://github.com/tpope/vim-fugitive) to perform Git operations directly from Neovim.  


### File Navigation (Harpoon)

| Mode   | Shortcut       | Action                                   |
|--------|----------------|-----------------------------------------|
| Normal | `<leader>a`    | Add current file to Harpoon bookmarks   |
| Normal | `<C-e>`        | Toggle Harpoon quick menu               |
| Normal | `A-h`          | Navigate to Harpoon file 1              |
| Normal | `A-t`          | Navigate to Harpoon file 2              |
| Normal | `A-n`          | Navigate to Harpoon file 3              |
| Normal | `A-h`          | Navigate to Harpoon file 4              |

**Description:**  
These shortcuts use [Harpoon](https://github.com/ThePrimeagen/harpoon) to quickly mark and navigate between frequently used files within the workspace.

### Fuzzy Finder (Telescope)

| Mode   | Shortcut       | Action                                     |
|--------|----------------|-------------------------------------------|
| Normal | `<leader>pf`   | Find files in the current workspace       |
| Normal | `<C-p>`        | Find files in the current workspace       |
| Normal | `<leader>ps`   | Search for a string with user input       |

**Description:**  
These shortcuts use [Telescope](https://github.com/nvim-telescope/telescope.nvim) for fuzzy finding and live text search inside your workspace.

### Undo History (undotree)

**Shortcut:**  

| Mode | Key | Action |
|------|-----|--------|
| Normal | `<leader>u` | Toggle the undo tree panel |

**Description:**  
This maps the `<leader>u` key to open or close the [undotree](https://github.com/mbbill/undotree) visualizer, which allows you to browse and revert to previous states of the current buffer.

---

## Syntax Highlighting & Parsing (nvim-treesitter)

**Description:**  
This setup uses [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) to provide enhanced syntax highlighting and parsing for multiple languages.

**Enabled Languages:**  
- C, C++  
- Lua  
- Vim script  
- Vim documentation  
- Tree-sitter query files

**Features:**  
- Automatic installation of missing parsers when opening a buffer (`auto_install = true`)  
- Synchronous installation is disabled (`sync_install = false`)  
- Highlights are enabled with minimal overlap with standard Vim syntax highlighting (`additional_vim_regex_highlighting = false`)

---
## Copilot plugin
GitHub Copilot is installed and enabled in this Neovim environment, but each user must authenticate with their own GitHub account the first time they use it.

### Authentication (TODO: Test)
When opening Neovim for the first time, Copilot shall manually be authenticated. This is done by opening `nvim` and typing `:Copilot setup`. Then, follow the provided steps.

Copilot stores authentication tokens in:
- `~/.config/github-copilot`
- `~/.local/state/nvim/copilot`

Because this environment runs inside a Docker container, these paths start fresh unless you persist them. To perform so, do the following:
```bash
# Edit scripts nvim.sh and add these volumes
docker run \
...
-v ~/.copilot-auth:/root/.config/github-copilot \
-v ~/.copilot-state:/root/.local/state/nvim/copilot \
...
```

This will keep the authentication across container runs.

---
## Clipboard
X11 clipboard is set to share it with a X11 host. This is configurable by setting to `yes|no` variable `ENABLE_X11_CLIPBOARD` on `docker.conf` file.

NOTE: The clipboard needs access to the DISPLAY server. This is already configured when enabling it.

---
## Known Issues
NOTHING by the moment.

---

## Limitations

- Paths outside the mounted volume may not be accessible or navigable in `Netrw`. Notice that the mounted volume is the opened directory in `dnvim`:
- .env files: ENV files are being processed by Bashls, just ignore appearing warnings.
- flash plugin: Flash plugin search is limited to search in the current screen, not further. For a secure search use default VIM search.

```bash
dnvim /home/user/a_folder/b_folder
# The user will not be able to navigate within the content of a_folder, to do so, open a_folder in Neovim:
dnvim /home/user/a_folder
# This way the user can navigate through folders a_folder and b_folder
```


---

## Contributing

Feel free to fork this repository and adjust configurations, add plugins, or improve the Docker setup. Pull requests and issues are welcome.

---

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See [LICENSE](./LICENSE) for details.
