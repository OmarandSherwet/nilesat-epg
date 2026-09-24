#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p build docs

if [[ ! -d build/iptv-org-epg ]]; then
  git clone --depth 1 https://github.com/iptv-org/epg.git build/iptv-org-epg
fi

mkdir -p build/iptv-org-epg/public
cp inputs/iptv-channels.xml build/iptv-org-epg/public/nilesat.channels.xml
(
  cd build/iptv-org-epg
  if [[ ! -d node_modules ]]; then npm ci; fi
  rm -f public/nilesat-grab.xml
  for attempt in 1 2 3; do
    if npm run grab --- \
      --channels=public/nilesat.channels.xml \
      --output=public/nilesat-grab.xml \
      --days=3 --timeout=20000 --maxConnections=3; then
      break
    fi
    if [[ "$attempt" -eq 3 ]]; then exit 1; fi
    sleep 20
  done
)

python3 scripts/build_nilesat_epg.py \
  inputs/services-public.xml build/guide \
  --aliases inputs/aliases.json \
  --extra-xml build/iptv-org-epg/public/nilesat-grab.xml \
  --min-channels 40 --min-programmes 1800

cp build/guide/nilesat.xml docs/nilesat.xml
cp build/guide/coverage.json docs/coverage.json
