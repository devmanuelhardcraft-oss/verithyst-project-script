#!/usr/bin/env bash

set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "================================="
echo " Verthyst Komplettinstallation"
echo "================================="


run()
{
    FILE="$1"

    if [ -f "$BASE_DIR/scripts/$FILE" ]; then

        echo
        echo "================================="
        echo " Starte $FILE"
        echo "================================="

        bash "$BASE_DIR/scripts/$FILE"

        echo
        echo "[OK] $FILE abgeschlossen"

        sleep 3

    else

        echo
        echo "[SKIP] $FILE nicht gefunden"

        sleep 2

    fi
}


run repos.sh
run update.sh
run packages.sh
run gaming.sh
run drivers.sh
run kernels.sh
run optimization.sh
run cleanup.sh


echo
echo "================================="
echo " Verthyst Installation fertig"
echo "================================="

read -p "ENTER drücken zum Zurückkehren..."

