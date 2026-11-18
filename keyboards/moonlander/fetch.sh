#!/usr/bin/env bash
# Refresh the Oryx layout snapshot (JSON + official QMK source) and regenerate
# the HTML overview. Firmware binaries are downloaded only to a temp dir and
# are never written into this folder.
#
# WARNING: qmk/ is the master copy once local edits exist. This script
# overwrites qmk/, oryx-layout.json, and index.html with a fresh Oryx export.
set -euo pipefail

cd "$(dirname "$0")"

HASH_ID="${HASH_ID:-Emvlv}"
GEOMETRY="${GEOMETRY:-moonlander}"
REVISION_ID="${REVISION_ID:-latest}"
ORYX_GRAPHQL="${ORYX_GRAPHQL:-https://oryx.zsa.io/graphql}"
ORYX_SOURCE_BASE="${ORYX_SOURCE_BASE:-https://oryx.zsa.io/source}"

if ! command -v curl >/dev/null || ! command -v python3 >/dev/null; then
  echo "fetch.sh needs curl and python3" >&2
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "Fetching Oryx layout ${HASH_ID} (${GEOMETRY}, revision ${REVISION_ID})..."

python3 - "$ORYX_GRAPHQL" "$HASH_ID" "$GEOMETRY" "$REVISION_ID" "$tmpdir/layout.json" << 'PY'
import json, sys, urllib.request

graphql, hash_id, geometry, revision_id, dest = sys.argv[1:]
query = """
{
  layout(hashId:%s, geometry:%s, revisionId:%s) {
    title
    hashId
    revision {
      hashId
      createdAt
      title
      qmkVersion
      config
      layers { title position color keys }
    }
  }
}
""" % (json.dumps(hash_id), json.dumps(geometry), json.dumps(revision_id))

req = urllib.request.Request(
    graphql,
    data=json.dumps({"query": query}).encode(),
    headers={"Content-Type": "application/json"},
    method="POST",
)
with urllib.request.urlopen(req, timeout=30) as resp:
    payload = json.load(resp)
if payload.get("errors"):
    raise SystemExit(f"Oryx GraphQL error: {payload['errors']}")
layout = payload["data"]["layout"]
if not layout or not layout.get("revision"):
    raise SystemExit("Oryx returned no revision for this layout")
doc = {
    "geometry": geometry,
    "layout": {
        "title": layout["title"],
        "hashId": layout["hashId"],
        "revision": layout["revision"],
    },
}
with open(dest, "w") as f:
    json.dump(doc, f, indent=2)
    f.write("\n")
rev = layout["revision"]
print(f"  title     {layout['title']}")
print(f"  revision  {rev['hashId']}")
print(f"  created   {rev.get('createdAt')}")
print(f"  qmk       {rev.get('qmkVersion')}")
print(f"  layers    {len(rev.get('layers') or [])}")
PY

cp "$tmpdir/layout.json" oryx-layout.json
revision_hash="$(python3 -c 'import json,sys; print(json.load(open("oryx-layout.json"))["layout"]["revision"]["hashId"])')"

echo "Downloading official QMK source for ${revision_hash}..."
curl -fsSL "$ORYX_SOURCE_BASE/$revision_hash" -o "$tmpdir/source.zip"

python3 - "$tmpdir/source.zip" "$PWD/qmk" << 'PY'
import sys, zipfile
from pathlib import Path

zip_path, dest = sys.argv[1], Path(sys.argv[2])
wanted = {
    "config.h",
    "keymap.c",
    "keymap.json",
    "rules.mk",
    "README.md",
}
dest.mkdir(parents=True, exist_ok=True)
kept = []
with zipfile.ZipFile(zip_path) as zf:
    for info in zf.infolist():
        name = Path(info.filename).name
        # Official zip ships compiled .bin firmware; never extract those.
        if name.endswith(".bin") or name.endswith(".md5") or name == "build.log":
            continue
        if name not in wanted:
            continue
        # Prefer the files inside the *_source folder; the zip also has a
        # top-level README.md with compile instructions — keep that too.
        target_name = name
        if name == "README.md" and "source/" not in info.filename.replace("\\", "/"):
            # Top-level Oryx compile README.
            pass
        data = zf.read(info)
        (dest / target_name).write_bytes(data)
        kept.append(target_name)
        print(f"  wrote qmk/{target_name}")
missing = wanted - set(kept)
if missing:
    print(f"  warning: missing from zip: {', '.join(sorted(missing))}", file=sys.stderr)
PY

echo "Regenerating index.html..."
python3 ./generate_overview.py oryx-layout.json index.html
echo "Done."
if [[ -f artifact.json ]]; then
  echo "Reminder: publish the new index.html with update_artifact (see README) so the Artifact Publisher link stays in sync."
fi
