#!/bin/bash

# SPDX-FileCopyrightText: 2026 Minoru Maekawa
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

## Post-Processing
function cleanup() {
	rm -rf "$OPENSSL_BUILD_DIR"
}

trap cleanup EXIT

## Variables
OPENSSL_BUILD_DIR="$(mktemp -d)"
OPENSSL_LIB_DIR=$HOME/.local/openssl
COMMON_FLAGS="-O2 -pipe -march=native -fdata-sections -ffunction-sections"
if command -v mold >/dev/null; then
	COMMON_FLAGS="${COMMON_FLAGS} -fuse-ld=mold"
fi

## GitHub CLI
if ! command -v gh >/dev/null; then
	echo "Error: gh command not found. Please install GitHub CLI."
	exit 1
fi

export \
	CFLAGS="${COMMON_FLAGS}" CXXFLAGS="${COMMON_FLAGS}" \
	LDFLAGS="-Wl,-s -Wl,--gc-sections" \
	KERL_CONFIGURE_OPTIONS="--enable-kernel-poll --enable-dirty-schedulers --disable-sctp --disable-dynamic-ssl-lib --disable-sharing-preserving --with-ssl=${OPENSSL_LIB_DIR} --without-javac --without-odbc --without-wx --without-ssh"

## OpenSSL local install
if [ ! -d "${OPENSSL_LIB_DIR}" ]; then
	(
		cd "$OPENSSL_BUILD_DIR"

		echo "Downloading latest release..."
		gh release download \
			--repo openssl/openssl \
			--pattern '*.tar.gz' \
			--output openssl.tar.gz

		echo "Extracting archive..."
		tar zxf openssl.tar.gz --strip-components=1

		# shellcheck disable=SC2016
		./Configure no-shared no-module no-docs --prefix="${OPENSSL_LIB_DIR}" '-Wl,-rpath,$(LIBRPATH)'
		make -j"$(nproc --all)" && make install
	)
fi

if command -v asdf >/dev/null; then
	echo "Detected asdf. Installing plugins via asdf..."
	asdf plugin list all | grep -E '^(erlang|elixir)' | tr -s "[:space:]" | xargs -L1 asdf plugin add
	asdf plugin list | sort -fr | xargs -I{} asdf set --home {} latest
	asdf install

elif command -v mise >/dev/null; then
	echo "Detected mise. Installing plugins via mise..."
	MISE_ERLANG_COMPILE=1 mise use -g erlang elixir elixir-ls
	eval "$(mise activate bash)"

else
	echo "Error: asdf and mise not found. Please install either asdf or mise."
	exit 1
fi

## Upgrade mix
mix local.hex --force
mix local.rebar --force
mix archive.install hex phx_new --force
