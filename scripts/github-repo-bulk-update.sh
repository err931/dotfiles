#!/bin/bash

# SPDX-FileCopyrightText: 2025 Minoru Maekawa
#
# SPDX-License-Identifier: MIT

set -uo pipefail

repos=$(gh repo list --json nameWithOwner -q '.[].nameWithOwner')
for repo in $repos; do
	echo "Processing: $repo"
	gh repo edit "${repo}" --enable-wiki=false --enable-issues --enable-discussions=false --enable-projects=false --enable-merge-commit=false --enable-squash-merge --enable-rebase-merge --allow-update-branch --enable-auto-merge --delete-branch-on-merge
	gh api -X PUT repos/"${repo}"/immutable-releases
	gh api -X PUT repos/"${repo}"/actions/permissions -F enabled=true -f allowed_actions=selected -F sha_pinning_required=true
	gh api -X PUT repos/"${repo}"/actions/permissions/workflow -F can_approve_pull_request_reviews=true
	gh api -X PUT repos/"${repo}"/actions/permissions/selected-actions -F github_owned_allowed=true -F verified_allowed=true
	sleep 1
done
