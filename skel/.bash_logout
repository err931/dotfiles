# ~/.bash_logout: executed by bash(1) when login shell exits.

if command -v podman &>/dev/null; then
    podman system prune -af --volumes
fi

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
