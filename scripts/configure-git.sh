#!/bin/env bash
set -euo pipefail

CONFIG_PATH=git/config
install -D /dev/null "${XDG_CONFIG_HOME:=$HOME/.config}"/$CONFIG_PATH

xargs -L1 git config --global <<EOS
user.name "Minoru Maekawa"
user.email 126235344+err931@users.noreply.github.com
alias.crebase "rebase --committer-date-is-author-date --signoff"
alias.irebase "rebase --ignore-date --signoff"
alias.fixup "commit --fixup HEAD"
alias.recommit "commit --amend --no-edit --reset-author"
alias.slog "log --show-signature"
color.ui true
core.autocrlf input
diff.algorithm histogram
diff.colorMoved dimmed-zebra
fetch.prune true
fetch.pruneTags true
format.pretty fuller
gc.pruneExpire now
gc.worktreePruneExpire now
init.defaultBranch main
log.abbrevCommit true
log.date iso
merge.ff false
pull.rebase true
push.useForceIfIncludes true
rebase.abbreviateCommands true
rebase.autoSquash true
rebase.autoStash true
rebase.updateRefs true
rerere.enabled true
status.showStash true
EOS
