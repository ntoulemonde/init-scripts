#!/bin/bash

# ---------------
# Git
# ---------------
# To use git clone with automated PAT
git config --global url."https://$GIT_PERSONAL_ACCESS_TOKEN@github.com/".insteadOf "https://github.com/"

# To avoid having to set the branch after having created it
git config --global push.autoSetupRemote true
sudo tee -a /etc/bash.bashrc << EOT
# git aliases
alias gc='git clone'
alias gcm='git commit -m'
alias gst='git status'
alias gsw='git switch'
alias gp='git push'
alias ga='git add'

EOT

# ---------------
# VS Code
# ---------------

#!/bin/bash

##### Config #####

# See here for the default settings enforced in Onyxia's VSCode-based images : https://github.com/InseeFrLab/images-datascience/blob/main/vscode/settings/User.json
# Expected parameters : None

# Define the configuration directory for VS Code
VSCODE_CONFIG_DIR="$HOME/.local/share/code-server/User"

# Create the configuration directory if necessary
mkdir -p "$VSCODE_CONFIG_DIR"

# Path to the VSCode settings.json file
SETTINGS_FILE="$VSCODE_CONFIG_DIR/settings.json"

# Check if the settings.json file exists, otherwise create a new one
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "No existing settings.json found. Creating a new one."
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    echo "{}" > "$SETTINGS_FILE"  # Initialize with an empty JSON object
fi

# Add or modify Python-related settings using jq. jq is a bash package to deal with JSON, cf https://jqlang.org/
# We will keep the comments outside the jq block, as jq doesn't support comments inside JSON.
# "workbench.colorTheme": Set the theme to dark
# "workbench.startupEditor": Remove start page 
# "workbench.secondarySideBar.defaultVisibility": remove side bar for AI
# "files.trimTrailingWhitespace":Automatically trim trailing whitespace
# "files.insertFinalNewline":Ensure files end with a newline
# "editor.rulers" : Add specific vertical rulers
jq '. + {
    "workbench.colorTheme": "Default Light Modern",  
    "workbench.startupEditor": "terminal",  
    "workbench.secondarySideBar.defaultVisibility": "hidden",  
    "files.trimTrailingWhitespace": true,  
    "files.insertFinalNewline": true,  
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.rulers": [80, 100, 120], 
    "editor.formatOnPaste": true,
    "editor.formatOnSave": true,
    "editor.formatOnSaveMode": "file",
    "editor.codeActionsOnSave": {
        "source.organizeImports": "always",
        "source.fixAll": "always"
    },
    "files.autoSave": "onFocusChange",
    "[R]": {
        "editor.defaultFormatter": "REditorSupport.r"
    },
    "[python]":{
        "editor.defaultFormatter": "charliermarsh.ruff"
    },
    "flake8.args": [
        "--max-line-length=100"  # Max line length for Python linting
    ],
    "ruff.importStrategy": "useBundled",
    "workbench.sideBar.location": "left"
}' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

# Keybindings file
KEYBINDINGS_FILE="$VSCODE_CONFIG_DIR/keybindings.json"

##### Shortcuts #####
# Add shortcuts for duplicating, deleting lines, and navigating tabs
echo '[
    {
        "key": "ctrl+d",
        "when": "editorTextFocus"
    },
    {
        "key": "ctrl+down",
        "command": "workbench.action.previousEditor"
    },
    {
        "key": "ctrl+up",
        "command": "workbench.action.nextEditor"
    },
    {
        "key": "ctrl+numpad2",
        "command": "workbench.action.terminal.focus"
    },
    {
        "key": "ctrl+alt+down",
        "command": "workbench.action.terminal.focusNext"
    },
    {
        "key": "ctrl+numpad8",
        "command": "workbench.action.focusActiveEditorGroup"
    },
    {
        "key": "ctrl+numpad4",
        "command": "workbench.files.action.focusFilesExplorer"
    }, 
    {
        "key": "ctrl+alt+i",
        "command": "editor.action.insertSnippet",
        "when": "editorTextFocus",
        "args": {"snippet": "```{python}\n$0\n```"}
    }
]' > "$KEYBINDINGS_FILE"

##### Extension #####
# Colorizes the indentation in front of text
code-server --install-extension oderwat.indent-rainbow

# Prettier code formatter, cf https://prettier.io/
code-server --install-extension esbenp.prettier-vscode

# Other extensions
# Extensive markdown integration : yzhang.markdown-all-in-one
code-server --install-extension $1
