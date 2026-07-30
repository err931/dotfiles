#!/bin/sh

# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: MIT

set -euo pipefail

gpg --quick-gen-key "Lorem Ipsum <lorem@example.com>" default cert 0
gpg --list-keys >/dev/null 2>&1

KEY_FPR=$(gpg --list-secret-keys --with-colons | awk -F: '$1 == "fpr" {print $10}')
gpg --quick-add-key $KEY_FPR default encr 0
gpg --quick-add-key $KEY_FPR default sign 0
rm -rf $HOME/.gnupg/S.*

cd
tar --format=pax -cf gnupg-keyring.tar .gnupg
GNUPGHOME=/tmp/.gnupg gpg --cipher-algo AES256 --compress-algo bzip2 -c gnupg-keyring.tar
