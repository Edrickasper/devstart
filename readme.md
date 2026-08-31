# DevStart

DevStart is a lightweight Bash CLI tool that helps you quickly find, select, open, and run development projects from your local machine — all from a single command.

## Features

- **Real-Time Directory Navigator:** Operates as an instantaneous, live TUI file browser without requiring any background indexing or caching.
- **TUI & Live Preview:** Fully interactive Terminal UI powered by `fzf`. Features a side-by-side layout with a live preview pane showing project details (`package.json`), Git status, and folder contents.
- **Interactive Navigation:** Drill down into subfolders or navigate back through your history using your keyboard, just like a file browser.
- **Smart Directory Pruning:** Automatically ignores heavy directories like `node_modules`, `dist`, `build`, `.cache`, `.venv`, and `.git` subfolders to keep your view clean.
- **Rich Keybindings:**
  - `Enter`: Open project and start dev server.
  - `Ctrl+E`: Open in editor only.
  - `Ctrl+T`: Open a new terminal window in the project folder.
  - `→` (Right Arrow): Drill down into a highlighted folder.
  - `←` (Left Arrow): Pop history and go back to the previous folder view.
- **Auto Editor Open:** Opens the selected project in VS Code (`code`) in the background.
- **Angular Auto-Serve:** Automatically runs `ng serve --open` for Angular apps.

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

---

*This project is proudly **vibecoded**.*
