# DevStart

DevStart is an interactive TUI (Text User Interface) project launcher for your terminal. It lets you browse, preview, and open development projects from a single command — powered by `fzf`.

## Features

- **Real-Time Directory Browser:** Instantly lists folders from your configured projects directory. No indexing, no caching — always up to date.
- **Live Preview Pane:** A side-by-side layout shows project details as you browse:
  - `package.json` info (name, version, description)
  - Git branch and status
  - Directory contents
- **Flicker-Free Navigation:** Drill down into subfolders and navigate back seamlessly using `fzf`'s internal reload — the TUI never flickers or restarts.
- **Smart Directory Pruning:** Automatically hides dot directories (`.git`, `.vscode`, etc.), `node_modules`, `dist`, `build`, and `coverage`.
- **Keybindings:**
  | Key | Action |
  |---|---|
  | `Enter` | Open project in editor & start dev server |
  | `Ctrl+E` | Open project in editor only |
  | `Ctrl+T` | Open a new terminal window in the project folder |
  | `→` (Right Arrow) | Drill down into the highlighted folder |
  | `←` (Left Arrow) | Go back to the previous folder |
- **Editor Auto-Detection:** Uses your `$EDITOR` environment variable. Falls back to `code` (VS Code) if not set.
- **Angular Auto-Serve:** If the selected project contains `angular.json`, automatically runs `ng serve --open`.

## Prerequisites

| Tool | Purpose |
|---|---|
| **Bash 4+** | Required to run the script |
| **[fzf](https://github.com/junegunn/fzf)** | Powers the interactive TUI |
| **[Git](https://git-scm.com/)** | Used for preview pane Git status (optional) |
| **An editor** | `$EDITOR` env var, or `code` (VS Code) as default |
| **[Angular CLI](https://angular.dev/tools/cli)** | Only needed if you work with Angular projects |

## Installation

Run the provided installer:

```bash
bash install.sh
```

The installer will:
1. Copy `devstart.sh` to `~/.local/bin/devstart` and make it executable.
2. Create the config directory at `~/.config/devstart/`.
3. Prompt you for the full path to your projects directory and generate the config file.

> **Note:** Make sure `~/.local/bin` is in your `$PATH`. Add the following to your `~/.bashrc` or `~/.zshrc` if it isn't:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

## Configuration

The config file is located at `~/.config/devstart/config`:

```bash
# ~/.config/devstart/config

PROJECTS_DIR="/path/to/your/projects"
```

| Variable | Description |
|---|---|
| `PROJECTS_DIR` | Root directory where your projects are stored |

You can also set these environment variables to customize behavior:

| Variable | Default | Description |
|---|---|---|
| `EDITOR` | `code` | Editor to open projects with |
| `TERMINAL` | `x-terminal-emulator` | Terminal emulator for `Ctrl+T` |

## Usage

Run from anywhere in your terminal:

```bash
devstart
```

1. Your project folders appear in a fuzzy-searchable list with a live preview pane.
2. Use `→` / `←` to browse into and out of folders.
3. Type to filter results.
4. Press `Enter` to open the selected project in your editor. If it's an Angular project, `ng serve --open` starts automatically.

---

*This project is completely **vibecoded**.*
