#!/bin/env bash
set -euo pipefail

shopt -s nullglob
for input_file in *.iso; do
  tmp_file=$(mktemp -u)
  output_file="${input_file%%.*}.webm"

  HandBrakeCLI \
    --main-feature \
    -i "$input_file" \
    -o "$tmp_file" \
    -f av_webm \
    -m \
    -e svt_av1_10bit \
    --encoder-preset 4 \
    -q 35 \
    -x tune=0:keyint=10s \
    --audio-lang-list jpn \
    -E opus \
    -B 192 &&
    {
      mv -f "$tmp_file" "./$output_file"
    }
done
