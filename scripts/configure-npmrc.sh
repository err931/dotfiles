#!/bin/env bash
set -euo pipefail

xargs -L1 npm config set <<EOS
init-author-email=126235344+err931@users.noreply.github.com
init-author-name="Minoru Maekawa"
init-author-url=https://github.com/err931
init-license=Elastic-2.0
init-version=0.1.0
EOS
