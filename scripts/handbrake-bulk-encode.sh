#!/bin/bash

# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

shopt -s nullglob
for input_file in *.iso; do
	tmp_file=$(mktemp)
	output_file="${input_file%%.*}.mp4"

	HandBrakeCLI \
		--main-feature \
		-i "$input_file" \
		-o "$tmp_file" \
		-f av_mp4 \
		-m \
		--encoder svt_av1_10bit \
		--encoder-preset 4 \
		-x enable-qm=1:qm-min=0 \
		--audio-lang-list eng,jpn \
		-E opus \
		-B 192 \
		--subtitle-lang-list eng,jpn \
		--first-subtitle &&
		{
			mv -f "$tmp_file" "./$output_file"
		}
done
