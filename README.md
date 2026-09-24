# Nilesat EPG

This project creates a conservative XMLTV guide for channel names in the
receiver's Nilesat bouquet. It combines the Arabic elCinema guide, public
country feeds, and selected `iptv-org/epg` grabbers. It discards empty or
stale programmes and does not invent listings for uncovered channels.

Run locally with `bash scripts/update.sh`. The GitHub Actions workflow runs
every six hours and commits a new guide only after minimum coverage checks
pass. The published file is `docs/nilesat.xml` and the coverage report is
`docs/coverage.json`.

The public `inputs/services-public.xml` contains only channel names and dummy
service references. The real Enigma2 service mapping stays on the receiver.
The live guide URL is:

`https://raw.githubusercontent.com/OmarandSherwet/nilesat-epg/main/docs/nilesat.xml`
