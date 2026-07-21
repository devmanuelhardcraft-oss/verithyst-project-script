#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Resetting Verthyst-Script development settings..."

rm -f "$BASE_DIR/config/language"

echo "Language reset complete."
