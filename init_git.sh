#!/bin/bash

# Sourcing default init scripts from InseeFrLab/sspcloud-init-scripts
SCRIPT_URL="https://raw.githubusercontent.com/InseeFrLab/sspcloud-init-scripts/refs/heads/main/vscode/customize-settings.sh"
# To pass it as an argument
# SCRIPT_URL=$1

SCRIPT_DEST="customize-settings.sh"

# Download scripts
curl --create-dirs --output "$SCRIPT_DEST" "$SCRIPT_URL"

# Source the scripts
source "$SCRIPT_DEST"
rm "$SCRIPT_DEST"

# Personnal init commands
# To use git clone with automated PAT
git config --global url."https://$GIT_PERSONAL_ACCESS_TOKEN@github.com/".insteadOf "https://github.com/"
git config --global url."https://$GIT_PERSONAL_ACCESS_TOKEN@github.com/".insteadOf "https://www.github.com/"

# To avoid having to set the branch after having created it
git config --global push.autoSetupRemote true

# VS Code
# Define the configuration directory for VS Code
VSCODE_CONFIG_DIR="$HOME/.local/share/code-server/User"

# Create the configuration directory if necessary
mkdir -p "$VSCODE_CONFIG_DIR"

# User settings file
SETTINGS_FILE="$VSCODE_CONFIG_DIR/settings.json"

# Enable dark mode by default
echo '{
    "workbench.colorTheme": "Default Dark Modern"
}' > "$SETTINGS_FILE"


# Keybindings file
KEYBINDINGS_FILE="$VSCODE_CONFIG_DIR/keybindings.json"

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
    }
]' > "$KEYBINDINGS_FILE"


sudo tee -a /etc/bash.bashrc << EOT
# git aliases
alias gc='git clone'
alias gcm='git commit -m'
alias gs='git status'
alias gp='git push'
alias ga='git add'

EOT