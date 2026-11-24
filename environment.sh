#!/usr/bin/env bash
# Shared path and user detection for Verthyst-Script.
# Source this file from any project script; do not depend on the caller's cwd.

_VERTHYST_ENV_SOURCE="${BASH_SOURCE[0]}"
VERTHYST_ROOT="$(cd -- "$(dirname -- "$_VERTHYST_ENV_SOURCE")" && pwd -P)"

# When launched through sudo, keep the identity of the desktop/terminal user.
VERTHYST_USER="${SUDO_USER:-${USER:-$(id -un)}}"

if ! VERTHYST_PASSWD_ENTRY="$(getent passwd "$VERTHYST_USER" 2>/dev/null)"; then
    printf '[Verthyst] Fehler: Benutzer "%s" wurde nicht gefunden.\n' "$VERTHYST_USER" >&2
    return 1 2>/dev/null || exit 1
fi

VERTHYST_HOME="$(printf '%s\n' "$VERTHYST_PASSWD_ENTRY" | cut -d: -f6)"
if [[ -z "$VERTHYST_HOME" || ! -d "$VERTHYST_HOME" ]]; then
    printf '[Verthyst] Fehler: Home-Verzeichnis für "%s" ist ungültig.\n' "$VERTHYST_USER" >&2
    return 1 2>/dev/null || exit 1
fi

VERTHYST_CONFIG_DIR="$VERTHYST_HOME/.config/verthyst-script"
VERTHYST_LOG_DIR="$VERTHYST_ROOT/logs"
VERTHYST_SCRIPTS_DIR="$VERTHYST_ROOT/scripts"
VERTHYST_GUI_DIR="$VERTHYST_ROOT/gui"
VERTHYST_TRANSLATIONS_DIR="$VERTHYST_ROOT/translations"
VERTHYST_KERNELS_DIR="$VERTHYST_ROOT/kernels"
VERTHYST_PACKAGES_DIR="$VERTHYST_ROOT/packages"

export VERTHYST_ROOT VERTHYST_USER VERTHYST_HOME VERTHYST_CONFIG_DIR
export VERTHYST_LOG_DIR VERTHYST_SCRIPTS_DIR VERTHYST_GUI_DIR
export VERTHYST_TRANSLATIONS_DIR VERTHYST_KERNELS_DIR VERTHYST_PACKAGES_DIR
