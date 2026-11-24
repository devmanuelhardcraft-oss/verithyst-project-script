#!/usr/bin/env bash
# Load translations and persist language for the invoking desktop user.

_LANGUAGE_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
_LANGUAGE_ROOT="$(cd -- "$_LANGUAGE_SCRIPT_DIR/.." && pwd -P)"
source "$_LANGUAGE_ROOT/environment.sh"

LANG_DIR="$VERTHYST_TRANSLATIONS_DIR"
CONFIG_DIR="$VERTHYST_CONFIG_DIR"
LANG_FILE="$CONFIG_DIR/language"

if [[ ! -d "$LANG_DIR" ]]; then
    echo "[Verthyst] Übersetzungsordner fehlt: $LANG_DIR" >&2
    return 1 2>/dev/null || exit 1
fi

# Create the config as the actual user, not root, even when started via sudo.
if [[ $EUID -eq 0 ]]; then
    install -d -o "$VERTHYST_USER" -g "$(id -gn "$VERTHYST_USER")" "$CONFIG_DIR"
else
    mkdir -p "$CONFIG_DIR"
fi

if [[ -f "$LANG_FILE" ]]; then
    LANG="$(<"$LANG_FILE")"
else
    clear
    cat <<'EOF'
===============================
        VERTHYST-SCRIPT
===============================

Select Language:

1) Deutsch
2) English
EOF
    read -r -p "Auswahl / Selection: " lang || lang=2
    case "$lang" in
        1) LANG=de ;;
        *) LANG=en ;;
    esac
    printf '%s\n' "$LANG" > "$LANG_FILE"
    if [[ $EUID -eq 0 ]]; then
        chown "$VERTHYST_USER:$(id -gn "$VERTHYST_USER")" "$LANG_FILE"
    fi
fi

case "$LANG" in
    de) source "$LANG_DIR/de.conf" ;;
    en) source "$LANG_DIR/en.conf" ;;
    *)
        echo "[Verthyst] Unbekannte Sprache '$LANG' in $LANG_FILE; verwende Englisch." >&2
        LANG=en
        source "$LANG_DIR/en.conf"
        ;;
esac
