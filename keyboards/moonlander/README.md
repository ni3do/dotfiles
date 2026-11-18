# ZSA Moonlander layout

Snapshot of the [Oryx](https://configure.zsa.io/moonlander/layouts/Emvlv/latest/0) layout **grokout** (`Emvlv`) for a ZSA Moonlander. This folder is reference material; it is not stowed into `$HOME`.

Current revision: **3vpmow** (17 Nov 2026, 20:07 CET), compiled against QMK **25.0**.

Open `index.html` in a browser for a self-contained overview of all five layers (works offline, no external assets).

## What's in here

| File | Purpose |
| --- | --- |
| `oryx-layout.json` | Pretty-printed Oryx revision JSON (keys, layers, config) |
| `index.html` | Visual overview of the 3×5+3 layout |
| `generate_overview.py` | Rebuilds `index.html` from the JSON |
| `fetch.sh` | Re-downloads the latest Oryx revision and official QMK source |
| `qmk/` | Official Oryx source export (`keymap.c`, `config.h`, `rules.mk`, `keymap.json`) |

Firmware `.bin` files are not stored in git. `fetch.sh` discards them if they are present in the Oryx zip.

## Settings

- Tapping term 190 ms, with D and F at 160 ms
- Permissive hold
- Chordal hold, thumbs excluded
- RGB timeout 15 minutes

The board is a strict 3×5+3: the outer Moonlander columns are unused. Home-row mods are Win / Alt / Shift / Ctrl on A S D F, mirrored on J K L `;`. Thumb holds: Tab / Del / Space → Sym, Backspace → Num, Esc → Nav, Enter → Fn. The two inner cluster keys are Hyper (Ctrl+Alt+Shift+Space) and Ctrl+Space on the base layer; the right cluster is Print Screen on Nav.

## Refresh from Oryx

Needs `curl` and `python3`.

```bash
cd keyboards/moonlander
./fetch.sh
```

That overwrites `oryx-layout.json`, replaces the files in `qmk/`, and regenerates `index.html`. To pin a specific revision instead of `latest`:

```bash
REVISION_ID=3vpmow ./fetch.sh
```

## Flash with Keymapp

The usual path is still Oryx, then [Keymapp](https://www.zsa.io/keymapp):

1. Open the layout in [Oryx](https://configure.zsa.io/moonlander/layouts/Emvlv/latest/0) and compile, **or** compile this source against [ZSA's QMK fork](https://github.com/zsa/qmk_firmware/) (see `qmk/README.md`).
2. Open Keymapp, put the Moonlander into bootloader mode (the reset button on the board, or the Boot key on the Fn layer: hold Enter and tap P).
3. Flash the resulting `.bin`.

Do not commit compiled firmware to this repository.
