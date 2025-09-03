@echo on
setlocal enabledelayedexpansion

cd codex-rs
cargo-bundle-licenses --format yaml --output ..\THIRDPARTY.yml
cargo build --release

if not exist "%PREFIX%\bin" mkdir "%PREFIX%\bin"
copy target\release\codex.exe "%PREFIX%\bin\"
