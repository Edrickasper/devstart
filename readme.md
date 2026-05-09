# DevStart

DevStart is a lightweight Bash CLI tool that helps you quickly find, select, open, and run development projects from your local machine — all from a single command.

## Features

- **Fast Project Discovery:** Uses `find` to scan your configured projects directory, automatically pruning heavy directories like `node_modules`, `dist`, `build`, `.cache`, `.venv`, and `.git` subfolders for speed.
- **Smart Project Recognition:** Identifies projects by looking for a `package.json`, `angular.json`, or a `.git` directory.
- **Fuzzy Search:** Pipes discovered projects into `fzf` for an interactive, fuzzy-searchable selection menu — only the relative project name is displayed, keeping the list clean.
- **Auto Editor Open:** Opens the selected project in VS Code (`code`) in the background.
- **Angular Auto-Serve:** If the selected project is an Angular app (contains `angular.json`), it automatically runs `ng serve --open` to start the dev server and launch it in the browser.
- **Config-Based Setup:** All configuration (projects directory, max search depth) lives in `~/.config/devstart/config`, keeping the script itself clean and portable.

## Prerequisites

Ensure the following are available on your system:

| Tool | Purpose |
|---|---|
| **Bash** | Required to run the scripts |
| **[fzf](https://github.com/junegunn/fzf)** | Interactive fuzzy-search project picker |
| **[VS Code](https://code.visualstudio.com/)** | Project editor (`code` must be in your `$PATH`) |
| **[Angular CLI](https://angular.dev/tools/cli)** | Auto-serves Angular projects (`ng` command) — only needed if you use Angular |

## Installation

Use the provided `install.sh` script to set everything up automatically:

```bash
bash install.sh
```

The installer will:
1. Copy `devstart.sh` to `~/.local/bin/devstart` and make it executable.
2. Create the config directory at `~/.config/devstart/`.
3. Prompt you to enter the full path to your projects directory and write a default config file.

> **Note:** Make sure `~/.local/bin` is in your `$PATH`. Add the following to your `~/.bashrc` or `~/.zshrc` if it isn't:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

## Configuration

The config file is located at `~/.config/devstart/config`. You can edit it manually at any time:

```bash
# ~/.config/devstart/config

PROJECTS_DIR="/path/to/your/projects"
MAX_DEPTH=4
```

| Variable | Description |
|---|---|
| `PROJECTS_DIR` | Root directory where your projects are stored |
| `MAX_DEPTH` | How many directory levels deep to search (default: `4`) |

## Usage

Once installed, simply run from anywhere in your terminal:

```bash
devstart
```

1. A fuzzy-searchable list of your projects will appear.
2. Type to filter, use arrow keys to navigate.
3. Press `Enter` to select a project.
4. The project opens in VS Code. If it's an Angular project, `ng serve --open` runs automatically.
