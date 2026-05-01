# DevStart

DevStart is a simple and efficient Bash script that helps you quickly find, select, open, and run development projects from your local machine.

## Features
- **Fast Project Discovery:** Uses `fd` to quickly scan your projects directory, automatically skipping heavy directories like `node_modules`, `dist`, `build`, etc.
- **Fuzzy Search:** Uses `fzf` to provide an interactive, fuzzy-searchable list of your projects.
- **Auto Editor Open:** Automatically opens the selected project in VS Code (`code`).
- **Angular Support:** If the selected project is an Angular application (contains an `angular.json`), it automatically runs `ng serve --open` to start the development server and open it in the browser.

## Prerequisites
To use this script, you need to have the following tools installed on your system:
- **Bash:** Standard Unix shell.
- **[fd](https://github.com/sharkdp/fd):** A fast and user-friendly alternative to `find`.
- **[fzf](https://github.com/junegunn/fzf):** A command-line fuzzy finder.
- **[VS Code](https://code.visualstudio.com/):** The `code` command must be available in your path (you can edit the script to use `nvim` or another editor).
- **[Angular CLI](https://angular.dev/tools/cli):** The `ng` command must be available if you want to auto-serve Angular projects.

## Installation & Setup
1. **Clone or download** the script.
2. **Make it executable:**
   ```bash
   chmod +x devstart
   ```
3. **Configure your projects directory:**
   Open the `devstart` script and update the `PROJECTS_DIR` variable to point to the root directory where your projects are stored.
   ```bash
   PROJECTS_DIR="/path/to/your/projects"
   ```
4. **(Optional) Add to PATH:** Move or symlink the script to a directory in your `$PATH` (e.g., `~/.local/bin` or `/usr/local/bin`) or set up a shell alias so you can run it from anywhere.
   ```bash
   alias devstart='/path/to/devstart/devstart'
   ```

## Usage
Simply run the script from your terminal:
```bash
./devstart
```
1. You will be presented with a fuzzy-searchable list of your projects.
2. Start typing to filter the list.
3. Press `Enter` to select a project.
4. The project will open in VS Code. If it's an Angular project, the development server will also start automatically.
