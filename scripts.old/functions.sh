#!/usr/bin/env bash

get_real_user()
{
    echo "${SUDO_USER:-$USER}"
}


get_user_home()
{
    eval echo "~$(get_real_user)"
}


run_as_user()
{
    if [ -n "$SUDO_USER" ]; then
        sudo -u "$SUDO_USER" "$@"
    else
        "$@"
    fi
}


fix_user_permissions()
{
    USER_NAME="$(get_real_user)"
    USER_HOME="$(get_user_home)"

    for TARGET in \
        "$USER_HOME/.config/verthyst-script" \
        "$USER_HOME/.config/MangoHud" \
        "$USER_HOME/.config/gamemode" \
        "$USER_HOME/.steam"
    do

        if [ -e "$TARGET" ]; then
            chown -R "$USER_NAME:$USER_NAME" "$TARGET" 2>/dev/null || true
        fi

    done
}
