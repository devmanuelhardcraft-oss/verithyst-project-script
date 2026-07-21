#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

LANG_DIR="$BASE_DIR/translations"
CONFIG_DIR="$BASE_DIR/config"

mkdir -p "$CONFIG_DIR"

LANG_FILE="$CONFIG_DIR/language"

if [ -f "$LANG_FILE" ]; then
    LANG=$(cat "$LANG_FILE")
else

clear

echo "
===============================
     VERTHYST-SCRIPT
===============================

Select Language:

1) Deutsch
2) English
"

read -p "Auswahl / Selection: " lang

case $lang in

1)
echo "de" > "$LANG_FILE"
;;

2)
echo "en" > "$LANG_FILE"
;;

*)
echo "en" > "$LANG_FILE"
;;

esac

fi

LANG=$(cat "$LANG_FILE")

if [ "$LANG" = "de" ]; then
    source "$LANG_DIR/de.conf"
else
    source "$LANG_DIR/en.conf"
fi
