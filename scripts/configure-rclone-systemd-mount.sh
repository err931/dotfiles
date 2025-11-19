#!/bin/bash

# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

if ! command -v crudini >/dev/null; then
	echo "Error: crudini not found. Please install crudini."
	exit 1
fi

UNIT_NAME="home-$(whoami)-Dropbox.mount"
UNIT_PATH="$HOME/.config/systemd/user/$UNIT_NAME"
install -Dm644 /dev/null "$UNIT_PATH"
crudini --ini-options=nospace --set "$UNIT_PATH" Unit After network-online.target
crudini --ini-options=nospace --set "$UNIT_PATH" Mount Type rclone
crudini --ini-options=nospace --set "$UNIT_PATH" Mount What dropbox:
crudini --ini-options=nospace --set "$UNIT_PATH" Mount Where "$HOME/Dropbox"
crudini --ini-options=nospace --set "$UNIT_PATH" Mount Options ro,vfs-cache-mode=full,cache-dir=/tmp/rclone-vfs-cache
crudini --ini-options=nospace --set "$UNIT_PATH" Install WantedBy default.target
systemctl --user daemon-reload
systemctl --user enable --now "$UNIT_NAME"
