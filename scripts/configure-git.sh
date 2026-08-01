#!/bin/sh

# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: MIT

set -euo pipefail

GIT_CONFIG_DIR="${XDG_CONFIG_HOME:=$HOME/.config}"
install -Dm644 /dev/null "$GIT_CONFIG_DIR/git/config"
cat <<EOS >"$GIT_CONFIG_DIR/git/ignore"
# Generic backup files
*.bak
*.back
*.backup

# Norton Ghost backup files
*.gho

# Generic original files
*.ori
*.orig
*.original

# Generic temporary files
*.tmp
*.temp
*.temporary

# https://mise.jdx.dev/configuration.html
# https://mise.jdx.dev/configuration/environments.html
.mise.*.local.toml
.mise.local.toml
mise.*.local.toml
mise.local.toml
.mise/*.local.toml
mise/*.local.toml
EOS

xargs -L1 git config --global <<EOS
user.name "Minoru Maekawa"
user.email 126235344+err931@users.noreply.github.com
alias.purge "clean -ffdx"
alias.fixup "commit --fixup HEAD"
alias.recommit "commit --amend --no-edit --reset-author"
color.ui true
core.autocrlf input
core.pager less
core.repositoryFormatVersion 1
diff.algorithm histogram
diff.colorMoved plain
fetch.prune true
fetch.pruneTags true
fetch.writeCommitGraph true
format.pretty fuller
gc.reflogExpire 1.months.ago
gc.worktreePruneExpire now
help.autocorrect prompt
init.defaultBranch main
log.abbrevCommit true
log.date iso
log.showSignature true
merge.conflictStyle zdiff3
pager.branch false
pull.rebase true
push.autoSetupRemote true
push.followTags true
rebase.abbreviateCommands true
rebase.autoSquash true
rebase.autoStash true
rebase.updateRefs true
status.showStash true
tag.sort -v:refname
EOS
