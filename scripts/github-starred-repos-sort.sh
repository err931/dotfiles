#!/bin/bash

# SPDX-FileCopyrightText: 2025 Minoru Maekawa
#
# SPDX-License-Identifier: MIT

set -euo pipefail

gh api user/starred --paginate -q ".[].full_name" | sort -fr -o starred_repos.txt
while read -r repo; do
	echo "Unstarring: $repo"
	gh api -X DELETE user/starred/"${repo}"
	sleep 1
done <starred_repos.txt

while read -r repo; do
	echo "Add Star: $repo"
	gh api -X PUT user/starred/"${repo}"
	sleep 1
done <starred_repos.txt
