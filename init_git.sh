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

# To avoid having to set the branch after having created it
git config --global push.autoSetupRemote true

