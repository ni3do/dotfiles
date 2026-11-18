# ZSA Moonlander layout

Snapshot of the [Oryx](https://configure.zsa.io/moonlander/layouts/Emvlv/latest/0) layout **grokout** (`Emvlv`) for a ZSA Moonlander, plus local QMK edits. This folder is reference material; it is not stowed into `$HOME`.

**The QMK source in `qmk/` is the master copy.** Oryx revision **3vpmow** (17 Nov 2026, 20:07 CET, QMK **25.0**) is the last imported snapshot and is behind as of the 18 Nov 2026 local changes below. Do not run `fetch.sh` unless you intend to overwrite those edits with a fresh Oryx export.

Open `index.html` in a browser for a self-contained overview of all five layers (works offline, no external assets, follows the OS light/dark setting).

## Published overview

The live page is **[Moonlander layout · grokout](https://app.artifactpublisher.com/artifact/hxa7Lg-YbA2_YV3DPgCKt8oq)** (Artifact Publisher, public unlisted link). The id and current version live in `artifact.json`.

After every layout change, keep the published page in sync:

1. Update `qmk/` (the master copy) and keep `oryx-layout.json` in sync with it.
2. If the board has been flashed, set `FIRMWARE["flashed"]` in `generate_overview.py` (or a top-level `"firmware"` object in the JSON) so the status line flips off “flash pending”.
3. `python3 generate_overview.py`
4. Publish the new `index.html` to the same artifact with the Artifact Publisher MCP tool `update_artifact`. Pass `artifact_id` and `expected_version` from `artifact.json`. The share link stays the same. Then write the new version back into `artifact.json`.

## What's in here

| File | Purpose |
| --- | --- |
| `oryx-layout.json` | Layout JSON used to render the overview (updated to match `qmk/` when we edit in code) |
| `index.html` | Visual overview of the 3×5+3 layout |
| `generate_overview.py` | Rebuilds `index.html` from the JSON. `FIRMWARE` at the top of the file drives the “built / flash pending” status line. |
| `artifact.json` | Artifact Publisher id, share URL, and current version |
| `fetch.sh` | Re-downloads the latest Oryx revision and official QMK source (overwrites local edits) |
| `qmk/` | QMK source (`keymap.c`, `config.h`, `rules.mk`, `keymap.json`) — source of truth |

Firmware `.bin` files are not stored in git. `fetch.sh` discards them if they are present in the Oryx zip.

## Settings

- Tapping term 190 ms, with D and F at 160 ms
- Permissive hold
- Chordal hold, thumbs excluded
- RGB timeout 15 minutes

The board is a strict 3×5+3: the outer Moonlander columns are unused. Home-row mods are Win / Alt / Shift / Ctrl on A S D F, mirrored on J K L `;`. Thumb holds: Tab / Space → Sym, Backspace → Num, Esc / Del → Nav, Enter → Fn. On the Nav layer the left thumbs are Win+Up and Win+Down, matching the right thumbs Win+Left / Win+Right / Snip. The two inner cluster keys are Hyper (Ctrl+Alt+Shift+Space) and Ctrl+Space on the base layer; the right cluster is Print Screen on Nav.

## Local changes since Oryx 3vpmow (18 Nov 2026)

1. Base-layer Delete (right thumb) hold is Nav (`LT(3, KC_DELETE)`), not Sym. Tap is still Delete.
2. Nav-layer left thumbs: Tab position is Win+Up, Backspace position is Win+Down. Esc stays transparent (it is the Nav hold).

## Refresh from Oryx

Needs `curl` and `python3`. This overwrites `oryx-layout.json`, the files in `qmk/`, and `index.html`, so re-apply any local QMK edits afterwards.

```bash
cd keyboards/moonlander
./fetch.sh
```

To pin a specific revision instead of `latest`:

```bash
REVISION_ID=3vpmow ./fetch.sh
```

After a fetch, regenerate the overview from the JSON (or from JSON you have updated to match `qmk/`):

```bash
python3 generate_overview.py
```

## Flash with Keymapp

Compile this source against [ZSA's QMK fork](https://github.com/zsa/qmk_firmware/) on the `firmware25` branch (see `qmk/README.md`), then flash with [Keymapp](https://www.zsa.io/keymapp):

1. Copy `qmk/` into `qmk_firmware/keyboards/zsa/moonlander/keymaps/<name>/`.
2. `qmk compile -kb zsa/moonlander/reva -km <name>` (use `revb` for a rev B board).
3. Open Keymapp, put the Moonlander into bootloader mode (the reset button on the board, or the Boot key on the Fn layer: hold Enter and tap P).
4. Flash the resulting `.bin`.

Oryx will not include the local changes until they are re-entered there. Do not commit compiled firmware to this repository.
