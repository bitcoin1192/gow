#!/bin/bash
set -e

source /opt/gow/bash-lib/utils.sh

# Default to Gamescope for gaming containers to avoid Sway wlroots backend assertions
if [ -z "$RUN_SWAY" ] && [ -z "$RUN_GAMESCOPE" ]; then
    export RUN_GAMESCOPE=1
fi

# Point WINEPREFIX to the persistent home directory managed by Wolf
if [ -z "$WINEPREFIX" ] || [ "$WINEPREFIX" = "/wineprefix" ]; then
    export WINEPREFIX="$HOME/.wine"
fi

# Seed the persistent wineprefix from template on first launch
if [ ! -f "$WINEPREFIX/system.reg" ]; then
    gow_log "First run: initializing persistent Wineprefix at $WINEPREFIX from template..."
    mkdir -p "$WINEPREFIX"
    cp -a /opt/wineprefix-template/. "$WINEPREFIX/"
    gow_log "Wineprefix initialization complete."
fi

# Ensure /wineprefix symlink points to the active persistent prefix
if [ ! -e /wineprefix ] || [ -L /wineprefix ]; then
    ln -sfn "$WINEPREFIX" /wineprefix 2>/dev/null || true
fi

source /opt/gow/launch-comp.sh
launcher wine /game/nfs.exe
