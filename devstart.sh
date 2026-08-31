#!/bin/bash

# --- PREVIEW FEATURE ---
if [ "$1" = "--preview" ]; then
  DIR="$2"
  if [ "$DIR" = "GO_BACK" ]; then
    echo -e "\n  🔙  \033[1;34mGo back to previous folder\033[0m"
    exit 0
  fi
  
  if [ ! -d "$DIR" ]; then
    echo "Directory not found: $DIR"
    exit 0
  fi

  echo -e "\033[1;36m📂 $DIR\033[0m\n"

  if [ -f "$DIR/package.json" ]; then
    echo -e "\033[1;33m📦 package.json\033[0m"
    grep -E '^[ \t]*"(name|version|description)"' "$DIR/package.json" | head -n 3 | sed 's/^[ \t]*//'
    echo ""
  fi

  if [ -d "$DIR/.git" ]; then
    echo -e "\033[1;32m🌱 Git Status\033[0m"
    BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
    echo -e "Branch: \033[1;35m$BRANCH\033[0m"
    git -C "$DIR" status -s | head -n 10
    echo ""
  fi

  echo -e "\033[1;34m📁 Contents\033[0m"
  ls -1 --color=always "$DIR" | head -n 10

  exit 0
fi

# --- LIST GENERATOR (For fzf reload) ---
if [ "$1" = "--list" ]; then
  SELECTED="$2"
  STATE_FILE="$HOME/.cache/devstart/state"
  HISTORY_FILE="${STATE_FILE}.history"
  CONFIG="$HOME/.config/devstart/config"
  [ -f "$CONFIG" ] && source "$CONFIG"

  if [ -f "$STATE_FILE" ]; then
    CURRENT_DIR=$(cat "$STATE_FILE")
  else
    CURRENT_DIR="$PROJECTS_DIR"
  fi

  if [ -n "$SELECTED" ]; then
    if [ "$SELECTED" = "GO_BACK" ]; then
      HISTORY=()
      if [ -f "$HISTORY_FILE" ]; then
        while IFS= read -r line; do
          [ -n "$line" ] && HISTORY+=("$line")
        done < "$HISTORY_FILE"
      fi
      
      if [ ${#HISTORY[@]} -gt 0 ]; then
        last_idx=$((${#HISTORY[@]} - 1))
        CURRENT_DIR="${HISTORY[$last_idx]}"
        unset 'HISTORY[$last_idx]'
        printf "%s\n" "${HISTORY[@]}" > "$HISTORY_FILE"
      else
        CURRENT_DIR="$PROJECTS_DIR"
        > "$HISTORY_FILE"
      fi
    elif [ -d "$SELECTED" ]; then
      echo "$CURRENT_DIR" >> "$HISTORY_FILE"
      CURRENT_DIR="$SELECTED"
    fi
    echo "$CURRENT_DIR" > "$STATE_FILE"
  fi

  if [ "$CURRENT_DIR" != "$PROJECTS_DIR" ]; then
    printf '%s|%s\n' "GO_BACK" ".. (Go Back)"
  fi
  
  find "$CURRENT_DIR" -mindepth 1 -maxdepth 1 -type d \
    \( -name ".*" -o -name node_modules -o -name dist -o -name build -o -name coverage \) -prune \
    -o -type d -print | sort | while IFS= read -r dir; do
      name=$(basename "$dir")
      printf '%s|%s\n' "$dir" "$name"
    done
  exit 0
fi

# --- MAIN SCRIPT ---
SCRIPT_PATH="$(realpath "$0" 2>/dev/null || echo "$0")"

CONFIG="$HOME/.config/devstart/config"
[ -f "$CONFIG" ] && source "$CONFIG"

mkdir -p "$HOME/.cache/devstart"
STATE_FILE="$HOME/.cache/devstart/state"
HISTORY_FILE="${STATE_FILE}.history"

# Initialize state
echo "$PROJECTS_DIR" > "$STATE_FILE"
> "$HISTORY_FILE"

while true; do
  LIST=$(bash "$SCRIPT_PATH" --list "")

  # Feed list via process substitution; fzf reads terminal from /dev/tty internally
  FZF_OUT=$(fzf \
    --expect=enter,ctrl-e,ctrl-t \
    --bind "right:reload(bash '$SCRIPT_PATH' --list {1})" \
    --bind "left:reload(bash '$SCRIPT_PATH' --list GO_BACK)" \
    --delimiter="|" \
    --with-nth=2 \
    --prompt="🚀 Select Project: " \
    --tiebreak=begin \
    --layout=reverse \
    --border=rounded \
    --border-label=" [Enter] Open & Run | [Ctrl+E] Editor | [Ctrl+T] Terminal | [→] Drill Down | [←] Go Back " \
    --border-label-pos=bottom \
    --info=inline \
    --preview="bash '$SCRIPT_PATH' --preview {1}" \
    --preview-window="right:50%:border-left" \
    < <(echo "$LIST"))

  STATUS=$?
  [ $STATUS -ne 0 ] && exit 0
  [ -z "$FZF_OUT" ] && exit 0

  KEY=$(head -n 1 <<< "$FZF_OUT")
  SELECTED=$(sed -n '2p' <<< "$FZF_OUT" | cut -d'|' -f1)

  [ -z "$SELECTED" ] && exit 0

  # If user hits Enter on GO_BACK, navigate up and reload UI
  if [ "$SELECTED" = "GO_BACK" ]; then
    bash "$SCRIPT_PATH" --list "GO_BACK" > /dev/null
    continue
  fi

  if [ "$KEY" = "enter" ]; then
    PROJECT="$SELECTED"
    break
  fi

  PROJECT="$SELECTED"

  if [ "$KEY" = "ctrl-e" ]; then
    EDITOR="${EDITOR:-code}"
    $EDITOR "$PROJECT" &
    exit 0
  fi

  if [ "$KEY" = "ctrl-t" ]; then
    TERMINAL=${TERMINAL:-x-terminal-emulator}
    if command -v "$TERMINAL" >/dev/null; then
      $TERMINAL --working-directory="$PROJECT" &
    elif command -v gnome-terminal >/dev/null; then
      gnome-terminal --working-directory="$PROJECT" &
    else
      echo "No terminal emulator configured."
      sleep 2
    fi
    exit 0
  fi

  break
done

# Ensure stdin is a real terminal for everything after fzf
exec < /dev/tty

EDITOR="${EDITOR:-code}"
if command -v "$EDITOR" >/dev/null 2>&1; then
  $EDITOR "$PROJECT" &
else
  echo "Editor '$EDITOR' not found. Please set \$EDITOR."
fi

if [ -f "$PROJECT/angular.json" ]; then
  cd "$PROJECT" || exit 0
  ng serve --open
fi
