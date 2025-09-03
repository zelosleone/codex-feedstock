#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CFLAGS="$CFLAGS -D_GNU_SOURCE"
export CXXFLAGS="$CXXFLAGS -D_GNU_SOURCE"

cd codex-rs
cargo-bundle-licenses --format yaml --output ../THIRDPARTY.yml
cargo build --release

mkdir -p "$PREFIX/bin"
install -m0755 "target/${CARGO_BUILD_TARGET}/release/codex" "$PREFIX/bin/"
