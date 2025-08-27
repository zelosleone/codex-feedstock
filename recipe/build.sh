#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Patch package.json to skip unnecessary prepare step
mv package.json package.json.bak
jq "del(.scripts.prepare)" < package.json.bak > package.json

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --global \
    --build-from-source \
    ./openai-codex-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

# Remove the symlink created by npm and create a proper wrapper script
rm -f ${PREFIX}/bin/codex

# Create wrapper script
tee ${PREFIX}/bin/codex << 'EOF'
#!/usr/bin/env bash
exec node "${CONDA_PREFIX}/lib/node_modules/@openai/codex/bin/codex.js" "$@"
EOF
chmod +x ${PREFIX}/bin/codex