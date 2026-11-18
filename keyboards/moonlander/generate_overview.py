#!/usr/bin/env python3
"""Generate a self-contained HTML overview from oryx-layout.json.

The JSON is kept in sync with the QMK source in qmk/, which is the master copy
once local edits diverge from Oryx.
"""

from __future__ import annotations

import json
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
JSON_PATH = HERE / "oryx-layout.json"
OUT_PATH = HERE / "index.html"

CET = timezone(timedelta(hours=1), name="CET")

LAYER_COLORS = {
    0: "#6100FF",
    1: "#00C070",
    2: "#00C8FF",
    3: "#FF9000",
    4: "#FF3040",
}

# 3x5 alpha indices plus thumbs and the two inner cluster keys.
LEFT_ROWS = [
    [8, 9, 10, 11, 12],
    [15, 16, 17, 18, 19],
    [22, 23, 24, 25, 26],
]
RIGHT_ROWS = [
    [44, 45, 46, 47, 48],
    [51, 52, 53, 54, 55],
    [57, 58, 59, 60, 61],
]
LEFT_THUMBS = [33, 34, 35]
RIGHT_THUMBS = [69, 70, 71]
LEFT_CLUSTER = 32
RIGHT_CLUSTER = 68

CODE_LABELS = {
    "KC_LEFT_GUI": "Win",
    "KC_RIGHT_GUI": "Win",
    "KC_LEFT_ALT": "Alt",
    "KC_RIGHT_ALT": "Alt",
    "KC_LEFT_SHIFT": "Shift",
    "KC_RIGHT_SHIFT": "Shift",
    "KC_LEFT_CTRL": "Ctrl",
    "KC_RIGHT_CTRL": "Ctrl",
    "KC_BSPC": "Bksp",
    "KC_ESCAPE": "Esc",
    "KC_DELETE": "Del",
    "KC_ENTER": "Enter",
    "KC_SPACE": "Space",
    "KC_TAB": "Tab",
    "KC_SCLN": ";",
    "KC_COMMA": ",",
    "KC_DOT": ".",
    "KC_SLASH": "/",
    "KC_GRAVE": "`",
    "KC_LBRC": "[",
    "KC_RBRC": "]",
    "KC_MINUS": "-",
    "KC_EQUAL": "=",
    "KC_TILD": "~",
    "KC_LCBR": "{",
    "KC_RCBR": "}",
    "KC_UNDS": "_",
    "KC_PLUS": "+",
    "KC_EXLM": "!",
    "KC_AT": "@",
    "KC_HASH": "#",
    "KC_DLR": "$",
    "KC_PERC": "%",
    "KC_BSLS": "\\",
    "KC_QUOTE": "'",
    "KC_LABK": "<",
    "KC_RABK": ">",
    "KC_PIPE": "|",
    "KC_DQUO": '"',
    "KC_COLN": ":",
    "KC_QUES": "?",
    "KC_CIRC": "^",
    "KC_AMPR": "&",
    "KC_ASTR": "*",
    "KC_LPRN": "(",
    "KC_RPRN": ")",
    "KC_HOME": "Home",
    "KC_PGDN": "PgDn",
    "KC_PAGE_UP": "PgUp",
    "KC_END": "End",
    "KC_LEFT": "Left",
    "KC_DOWN": "Down",
    "KC_UP": "Up",
    "KC_RIGHT": "Right",
    "CW_TOGG": "Caps Word",
    "KC_PSCR": "PrtSc",
    "KC_AUDIO_VOL_UP": "Vol+",
    "KC_AUDIO_VOL_DOWN": "Vol−",
    "KC_AUDIO_MUTE": "Mute",
    "KC_MEDIA_PREV_TRACK": "Prev",
    "KC_MEDIA_PLAY_PAUSE": "Play",
    "KC_MEDIA_NEXT_TRACK": "Next",
    "KC_MS_BTN1": "Click 1",
    "KC_MS_BTN3": "Click 3",
    "KC_MS_BTN2": "Click 2",
    "QK_BOOT": "Boot",
    "KC_MS_LEFT": "Ms Left",
    "KC_MS_DOWN": "Ms Down",
    "KC_MS_UP": "Ms Up",
    "KC_MS_RIGHT": "Ms Right",
    "KC_MS_WH_LEFT": "Wh Left",
    "KC_MS_WH_DOWN": "Wh Down",
    "KC_MS_WH_UP": "Wh Up",
    "KC_MS_WH_RIGHT": "Wh Right",
}

MOD_ORDER = (
    ("leftCtrl", "Ctrl"),
    ("leftAlt", "Alt"),
    ("leftShift", "Shift"),
    ("leftGui", "Win"),
    ("rightCtrl", "Ctrl"),
    ("rightAlt", "Alt"),
    ("rightShift", "Shift"),
    ("rightGui", "Win"),
)

COMBO_LABELS = {
    frozenset({"leftCtrl", "leftAlt", "leftShift"}): {
        "KC_SPACE": ("Hyper", "Ctrl+Alt+Shift+Space"),
    },
    frozenset({"leftCtrl"}): {
        "KC_SPACE": ("Ctrl+Space", "Ctrl+Space"),
        "KC_Z": ("Undo", "Ctrl+Z"),
        "KC_X": ("Cut", "Ctrl+X"),
        "KC_C": ("Copy", "Ctrl+C"),
        "KC_V": ("Paste", "Ctrl+V"),
        "KC_Y": ("Redo", "Ctrl+Y"),
    },
    frozenset({"leftGui"}): {
        "KC_LEFT": ("Win+←", "Win+Left"),
        "KC_RIGHT": ("Win+→", "Win+Right"),
        "KC_UP": ("Win+↑", "Win+Up"),
        "KC_DOWN": ("Win+↓", "Win+Down"),
    },
    frozenset({"leftGui", "leftShift"}): {
        "KC_S": ("Snip", "Win+Shift+S"),
    },
}


def esc(text: str) -> str:
    return (
        text.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


def layout_root(data: dict) -> tuple[dict, dict]:
    if "data" in data and isinstance(data["data"], dict):
        data = data["data"]
    layout = data.get("layout", data)
    revision = layout.get("revision", layout)
    return layout, revision


def parse_created_at(raw: str | None) -> str:
    if not raw:
        return "unknown date"
    text = raw.strip()
    for fmt in ("%Y-%m-%d %H:%M:%S %Z", "%Y-%m-%dT%H:%M:%SZ", "%Y-%m-%d %H:%M:%S UTC"):
        try:
            if text.endswith(" UTC"):
                dt = datetime.strptime(text, "%Y-%m-%d %H:%M:%S UTC").replace(tzinfo=timezone.utc)
            elif text.endswith("Z") and "T" in text:
                dt = datetime.strptime(text, "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
            else:
                dt = datetime.strptime(text, fmt)
                if dt.tzinfo is None:
                    dt = dt.replace(tzinfo=timezone.utc)
            local = dt.astimezone(CET)
            return f"{local.day} {local.strftime("%b %Y, %H:%M CET")}"
        except ValueError:
            continue
    return text


def letter_label(code: str) -> str:
    if code in CODE_LABELS:
        return CODE_LABELS[code]
    if code.startswith("KC_") and len(code) == 4:
        ch = code[3]
        if ch.isalnum():
            return ch
    if code.startswith("KC_F") and code[4:].isdigit():
        return "F" + code[4:]
    if code.startswith("KC_"):
        return code[3:].replace("_", " ").title()
    return code


def active_mods(modifiers: dict | None) -> frozenset[str]:
    if not modifiers:
        return frozenset()
    return frozenset(k for k, v in modifiers.items() if v)


def format_binding(bind: dict | None, layer_names: dict[int, str]) -> tuple[str | None, str | None, str | None]:
    """Return (label, tooltip, hold_layer_name_if_mo)."""
    if not bind:
        return None, None, None
    code = bind.get("code")
    if not code or code == "KC_TRANSPARENT":
        return None, None, None
    if code == "MO":
        layer = bind.get("layer")
        name = layer_names.get(layer, f"L{layer}")
        return name, f"Momentary layer: {name}", name
    mods = active_mods(bind.get("modifiers"))
    pretty = letter_label(code)
    if mods:
        combo = COMBO_LABELS.get(mods, {}).get(code)
        if combo:
            return combo[0], combo[1], None
        prefix = "+".join(label for key, label in MOD_ORDER if key in mods)
        tip = f"{prefix}+{pretty}"
        return tip, tip, None
    return pretty, pretty, None


def key_state(key: dict | None, layer_names: dict[int, str]) -> dict:
    if not key:
        return {"kind": "empty"}
    tap = key.get("tap")
    hold = key.get("hold")
    if tap and tap.get("code") == "KC_TRANSPARENT" and not hold:
        return {"kind": "trans", "title": "Transparent (falls through)"}
    tap_label, tap_tip, _ = format_binding(tap, layer_names)
    hold_label, hold_tip, hold_layer = format_binding(hold, layer_names)
    if not tap_label and not hold_label:
        return {"kind": "empty"}
    tips = [t for t in (tap_tip, f"hold {hold_tip}" if hold_tip else None) if t]
    term = key.get("tappingTerm")
    if term:
        tips.append(f"tapping term {term} ms")
    return {
        "kind": "used",
        "tap": tap_label,
        "hold": hold_label,
        "hold_layer": hold_layer,
        "term": term,
        "title": " · ".join(tips),
    }


WRAP_LABELS = {
    "Ctrl+Space": "Ctrl+\nSpace",
    "Caps Word": "Caps\nWord",
    "Click 1": "Click\n1",
    "Click 2": "Click\n2",
    "Click 3": "Click\n3",
    "Ms Left": "Ms\nLeft",
    "Ms Down": "Ms\nDown",
    "Ms Up": "Ms\nUp",
    "Ms Right": "Ms\nRight",
    "Wh Left": "Wh\nLeft",
    "Wh Down": "Wh\nDown",
    "Wh Up": "Wh\nUp",
    "Wh Right": "Wh\nRight",
}


def render_key(state: dict, color: str, cluster: bool = False) -> str:
    kind = state["kind"]
    extra = " cluster" if cluster else ""
    if kind == "empty":
        return f'<div class="key empty{extra}" aria-hidden="true"></div>'
    if kind == "trans":
        return (
            f'<div class="key trans{extra}" title="{esc(state["title"])}">'
            '<span class="tap trans-mark">▽</span></div>'
        )
    classes = f"key used{extra}"
    if state.get("hold"):
        classes += " has-hold"
    if state.get("term"):
        classes += " has-term"
    hold_class = ""
    if state.get("hold_layer"):
        hold_class = f' hold-layer-{esc(state["hold_layer"].lower())}'
    tap = state.get("tap") or ""
    visual = WRAP_LABELS.get(tap, tap)
    long_class = " long" if "\n" in visual or len(tap) >= 7 else ""
    parts = [f'<div class="{classes}" style="--key-color:{color}" title="{esc(state["title"])}">']
    parts.append(f'<span class="tap{long_class}">{esc(visual)}</span>')
    if state.get("hold"):
        parts.append(f'<span class="hold{hold_class}">{esc(state["hold"])}</span>')
    if state.get("term"):
        parts.append(f'<span class="term">{int(state["term"])}</span>')
    parts.append("</div>")
    return "".join(parts)


def render_row(keys: list[dict], indices: list[int], layer_names: dict[int, str], color: str) -> str:
    cells = []
    for idx in indices:
        cells.append(render_key(key_state(keys[idx] if idx < len(keys) else None, layer_names), color))
    return '<div class="row">' + "".join(cells) + "</div>"


HTML = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Moonlander · {title} · {revision}</title>
<style>
  :root {{
    --bg: #101216;
    --bg-elev: #171a20;
    --bg-key: #22262f;
    --bg-empty: #181b21;
    --line: #2a2f3a;
    --text: #e8eaef;
    --muted: #8b909c;
    --soft: #c5c8d0;
    --base: #6100FF;
    --sym: #00C070;
    --num: #00C8FF;
    --nav: #FF9000;
    --fn: #FF3040;
  }}
  * {{ box-sizing: border-box; }}
  html, body {{ margin: 0; padding: 0; background: var(--bg); color: var(--text); }}
  body {{
    font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", "Helvetica Neue", sans-serif;
    line-height: 1.45;
    min-height: 100vh;
  }}
  a {{ color: #9cbcff; text-decoration: none; }}
  a:hover {{ text-decoration: underline; }}
  .wrap {{ max-width: 980px; margin: 0 auto; padding: 36px 20px 64px; }}
  header h1 {{
    font-size: 1.55rem;
    font-weight: 650;
    letter-spacing: -0.02em;
    margin: 0 0 6px;
  }}
  header .sub {{
    color: var(--muted);
    font-size: 0.95rem;
    margin: 0 0 16px;
  }}
  header .sub code, .mono {{
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: 0.9em;
  }}
  .settings {{
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin: 0 0 18px;
  }}
  .pill {{
    background: var(--bg-elev);
    border: 1px solid var(--line);
    border-radius: 999px;
    padding: 5px 11px;
    font-size: 0.8rem;
    color: var(--soft);
  }}
  .legend {{
    display: flex;
    flex-wrap: wrap;
    gap: 10px 16px;
    margin: 0 0 22px;
    padding: 14px 16px;
    background: var(--bg-elev);
    border: 1px solid var(--line);
    border-radius: 14px;
    font-size: 0.88rem;
  }}
  .legend strong {{ font-weight: 600; }}
  .swatch {{
    display: inline-block;
    width: 0.7em;
    height: 0.7em;
    border-radius: 3px;
    margin-right: 6px;
    vertical-align: -1px;
  }}
  .legend-sep {{ color: #4a5160; margin: 0 2px; }}
  .tabs {{
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    margin: 0 0 22px;
  }}
  .tabs button {{
    appearance: none;
    background: var(--bg-elev);
    color: var(--soft);
    border: 1px solid var(--line);
    border-radius: 10px;
    padding: 7px 13px;
    font: inherit;
    font-size: 0.88rem;
    cursor: pointer;
  }}
  .tabs button:hover {{ border-color: #4a5160; }}
  .tabs button[aria-selected="true"] {{
    color: #fff;
    border-color: transparent;
    background: #2c3140;
  }}
  .tabs button[data-layer="all"][aria-selected="true"] {{ background: #2c3140; }}
  .tabs button[data-layer="0"][aria-selected="true"] {{ background: var(--base); }}
  .tabs button[data-layer="1"][aria-selected="true"] {{ background: var(--sym); color: #062015; }}
  .tabs button[data-layer="2"][aria-selected="true"] {{ background: var(--num); color: #062018; }}
  .tabs button[data-layer="3"][aria-selected="true"] {{ background: var(--nav); color: #2a1500; }}
  .tabs button[data-layer="4"][aria-selected="true"] {{ background: var(--fn); }}
  .layer {{
    background: var(--bg-elev);
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 20px 18px 22px;
    margin: 0 0 18px;
  }}
  .layer h2 {{
    margin: 0 0 16px;
    font-size: 1.05rem;
    font-weight: 650;
    display: flex;
    align-items: baseline;
    gap: 10px;
  }}
  .layer h2 .hint {{
    color: var(--muted);
    font-size: 0.82rem;
    font-weight: 500;
  }}
  .board {{
    display: flex;
    justify-content: center;
    align-items: flex-start;
    gap: 52px;
    flex-wrap: wrap;
  }}
  .half {{
    display: flex;
    flex-direction: column;
    gap: 7px;
  }}
  .row, .thumbs {{
    display: flex;
    gap: 7px;
  }}
  .half.left .thumbs {{ justify-content: flex-end; }}
  .half.right .thumbs {{ justify-content: flex-start; flex-direction: row-reverse; }}
  .half.right .thumb-row {{ flex-direction: row; }}
  .thumb-row {{
    display: flex;
    gap: 7px;
  }}
  .cluster {{
    display: flex;
    align-items: flex-end;
    margin: 0 4px 34px 4px;
  }}
  .thumbs {{
    margin-top: 14px;
    align-items: flex-end;
  }}
  .key {{
    width: 62px;
    height: 62px;
    border-radius: 11px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    position: relative;
    border: 1px solid transparent;
    user-select: none;
    padding: 4px 3px 5px;
  }}
  .key.empty {{
    background: #1c2028;
    border: 1px solid #323846;
  }}
  .key.trans {{
    background: #1c2028;
    border: 1px dashed #5a6272;
    color: #8b909c;
  }}
  .key.cluster {{
    width: 58px;
    height: 58px;
  }}
  .key.used {{
    background: var(--key-color);
    color: #fff;
    box-shadow: inset 0 1px 0 rgba(255,255,255,0.18), 0 6px 14px rgba(0,0,0,0.22);
  }}
  .key .tap {{
    font-weight: 650;
    font-size: 0.92rem;
    letter-spacing: -0.01em;
    line-height: 1.15;
    white-space: pre-line;
  }}
  .key .tap.long {{ font-size: 0.68rem; font-weight: 650; }}
  .key .tap.trans-mark {{ font-weight: 400; font-size: 0.85rem; white-space: nowrap; }}
  .key.has-hold .tap {{ margin-top: -2px; }}
  .key .hold {{
    margin-top: 3px;
    font-size: 0.62rem;
    font-weight: 600;
    letter-spacing: 0.02em;
    text-transform: uppercase;
    color: rgba(255,255,255,0.82);
    line-height: 1;
  }}
  .hold-layer-sym {{ color: #9ff3c8 !important; }}
  .hold-layer-num {{ color: #b9f0ff !important; }}
  .hold-layer-nav {{ color: #ffd399 !important; }}
  .hold-layer-fn {{ color: #ffc1c6 !important; }}
  .key .term {{
    position: absolute;
    top: 3px;
    right: 4px;
    font-size: 0.55rem;
    font-weight: 700;
    letter-spacing: 0;
    color: #fff;
    text-transform: none;
    background: rgba(0,0,0,0.28);
    border-radius: 4px;
    padding: 0 3px;
    line-height: 1.3;
  }}
  .note {{
    margin: 8px 0 0;
    color: var(--muted);
    font-size: 0.8rem;
    text-align: center;
  }}
  footer {{
    margin-top: 10px;
    color: var(--muted);
    font-size: 0.8rem;
  }}
  body.single .layer {{ display: none; }}
  body.single .layer.is-active {{ display: block; }}
  @media (max-width: 760px) {{
    .board {{ gap: 22px; }}
    .key {{ width: 52px; height: 52px; border-radius: 9px; }}
    .key .tap {{ font-size: 0.8rem; }}
  }}
  @media print {{
    body {{ background: #fff; color: #111; }}
    .tabs {{ display: none; }}
    .layer {{ break-inside: avoid; border-color: #ccc; background: #fff; }}
    .key.empty {{ background: #f3f3f3; }}
  }}
</style>
</head>
<body>
  <div class="wrap">
    <header>
      <h1>ZSA Moonlander · {title}</h1>
      <p class="sub">
        Revision <code>{revision}</code>
        · {created}
        · QMK {qmk_version}
        · <a href="https://configure.zsa.io/moonlander/layouts/Emvlv/latest/0">Open in Oryx</a>
        {local_note}
      </p>
      <div class="settings">
        {settings}
      </div>
    </header>
    <div class="legend" aria-label="Thumb layer holds">
      {legend}
    </div>
    <div class="tabs" role="tablist" aria-label="Layers">
      <button type="button" role="tab" data-layer="all" aria-selected="true">Show all</button>
      {tab_buttons}
    </div>
    {layers}
    <p class="note">3×5+3 layout; unused outer columns are omitted. The raised inner keys are the Moonlander cluster keys.</p>
    <footer>Generated from <span class="mono">oryx-layout.json</span> (kept in sync with the QMK source in <span class="mono">qmk/</span>, which is the master copy). Base Oryx snapshot is <span class="mono">Emvlv</span> / revision <span class="mono">{revision}</span>.</footer>
  </div>
<script>
(function () {{
  const buttons = Array.from(document.querySelectorAll(".tabs button"));
  const layers = Array.from(document.querySelectorAll(".layer"));
  function show(id, updateHash) {{
    const valid = buttons.some((btn) => btn.dataset.layer === id) ? id : "all";
    document.body.classList.toggle("single", valid !== "all");
    layers.forEach((el) => el.classList.toggle("is-active", el.dataset.layer === valid));
    buttons.forEach((btn) => btn.setAttribute("aria-selected", String(btn.dataset.layer === valid)));
    if (updateHash) {{
      history.replaceState(null, "", valid === "all" ? location.pathname + location.search : "#" + valid);
    }}
  }}
  buttons.forEach((btn) => btn.addEventListener("click", () => show(btn.dataset.layer, true)));
  show((location.hash || "#all").slice(1), false);
}})();
</script>
</body>
</html>
"""


def settings_pills(config: dict, layers: list[dict]) -> str:
    pills = []
    term = config.get("tappingTerm")
    if term is not None:
        pills.append(f"Tapping term {term} ms")
    if config.get("perKeyTappingTerm"):
        # collect distinct per-key terms from base layer
        terms = []
        if layers:
            for i, key in enumerate(layers[0].get("keys") or []):
                t = (key or {}).get("tappingTerm")
                if t:
                    terms.append((i, t))
        if terms:
            # D=17, F=18 on this board
            labels = []
            names = {17: "D", 18: "F"}
            for i, t in terms:
                labels.append(f"{names.get(i, f'#{i}')} {t} ms")
            pills.append("Per-key: " + ", ".join(labels))
        else:
            pills.append("Per-key tapping term")
    if config.get("permissiveHold"):
        pills.append("Permissive hold")
    if config.get("chordalHold"):
        extra = " (thumbs excluded)" if config.get("chordalHoldExcludeThumbs") else ""
        pills.append("Chordal hold" + extra)
    timeout = config.get("rgbTimeout")
    if timeout is not None:
        pills.append(f"RGB timeout {timeout} min")
    return "".join(f'<span class="pill">{esc(p)}</span>' for p in pills)


def legend_html(layer_names: dict[int, str], layers: list[dict]) -> str:
    # Derive thumb holds from base layer
    base = (layers[0].get("keys") if layers else []) or []
    items = []
    order = [
        (33, "Tab"),
        (34, "Bksp"),
        (35, "Esc"),
        (69, "Del"),
        (70, "Enter"),
        (71, "Space"),
    ]
    for idx, fallback in order:
        key = base[idx] if idx < len(base) else None
        state = key_state(key, layer_names)
        tap = state.get("tap") or fallback
        hold = state.get("hold")
        color = LAYER_COLORS.get(next((i for i, n in layer_names.items() if n == hold), None), "#888")
        if hold:
            items.append(
                f'<span><strong>{esc(tap)}</strong> hold '
                f'<span class="swatch" style="background:{color}"></span>'
                f'<strong>{esc(hold)}</strong></span>'
            )
    return '<span class="legend-sep">·</span>'.join(items)


def layer_hint(idx: int, title: str, layers: list[dict], layer_names: dict[int, str]) -> str:
    if idx != 0:
        # find which base thumbs hold this layer
        base = (layers[0].get("keys") if layers else []) or []
        holders = []
        for i, fallback in ((33, "Tab"), (34, "Bksp"), (35, "Esc"), (69, "Del"), (70, "Enter"), (71, "Space")):
            st = key_state(base[i] if i < len(base) else None, layer_names)
            if st.get("hold") == title:
                holders.append(st.get("tap") or fallback)
        if holders:
            if len(holders) == 1:
                return f"hold {holders[0]}"
            return "hold " + ", ".join(holders[:-1]) + " or " + holders[-1]
        return ""
    return "home-row mods on A S D F and J K L ;"


def build_layer(idx: int, layer: dict, layer_names: dict[int, str]) -> str:
    title = layer.get("title") or layer_names[idx]
    color = layer.get("color") or LAYER_COLORS[idx]
    keys = layer.get("keys") or []
    hint = layer_hint(idx, title, [layer], layer_names)  # placeholder, fixed by caller
    left_rows = "".join(render_row(keys, row, layer_names, color) for row in LEFT_ROWS)
    right_rows = "".join(render_row(keys, row, layer_names, color) for row in RIGHT_ROWS)
    left_thumbs = "".join(render_key(key_state(keys[i], layer_names), color) for i in LEFT_THUMBS)
    right_thumbs = "".join(render_key(key_state(keys[i], layer_names), color) for i in RIGHT_THUMBS)
    left_cluster = render_key(key_state(keys[LEFT_CLUSTER], layer_names), color, cluster=True)
    right_cluster = render_key(key_state(keys[RIGHT_CLUSTER], layer_names), color, cluster=True)
    return f"""
    <section class="layer" data-layer="{idx}" data-title="{esc(title)}">
      <h2 style="color:{color}">{esc(title)} <span class="hint">{esc(hint)}</span></h2>
      <div class="board">
        <div class="half left">
          {left_rows}
          <div class="thumbs">
            <div class="thumb-row">{left_thumbs}</div>
            <div class="cluster">{left_cluster}</div>
          </div>
        </div>
        <div class="half right">
          {right_rows}
          <div class="thumbs">
            <div class="thumb-row">{right_thumbs}</div>
            <div class="cluster">{right_cluster}</div>
          </div>
        </div>
      </div>
    </section>
    """


def main() -> int:
    src = Path(sys.argv[1]) if len(sys.argv) > 1 else JSON_PATH
    dest = Path(sys.argv[2]) if len(sys.argv) > 2 else OUT_PATH
    data = json.loads(src.read_text())
    layout, revision = layout_root(data)
    layers = revision.get("layers") or []
    layer_names = {i: (L.get("title") or f"L{i}") for i, L in enumerate(layers)}
    config = revision.get("config") or {}
    title = layout.get("title") or "Moonlander"
    revision_id = revision.get("hashId") or "unknown"
    created = parse_created_at(revision.get("createdAt"))
    qmk_version = revision.get("qmkVersion") or "?"
    local_note_text = data.get("localNote") or revision.get("localNote") or ""
    local_note = f'<br><span>{esc(local_note_text)}</span>' if local_note_text else ""

    # Fix hints using the full layer list (base thumbs).
    sections = []
    for i, layer in enumerate(layers):
        html = build_layer(i, layer, layer_names)
        hint = layer_hint(i, layer_names[i], layers, layer_names)
        html = html.replace(
            f'<span class="hint">{esc(layer_hint(i, layer_names[i], [layer], layer_names))}</span>',
            f'<span class="hint">{esc(hint)}</span>',
            1,
        )
        sections.append(html)

    tab_buttons = []
    for i, name in layer_names.items():
        color = layers[i].get("color") or LAYER_COLORS[i]
        tab_buttons.append(
            f'<button type="button" role="tab" data-layer="{i}" aria-selected="false">{esc(name)}</button>'
        )

    html = HTML.format(
        title=esc(title),
        revision=esc(revision_id),
        created=esc(created),
        qmk_version=esc(str(qmk_version)),
        local_note=local_note,
        settings=settings_pills(config, layers),
        legend=legend_html(layer_names, layers),
        tab_buttons="".join(tab_buttons),
        layers="".join(sections),
    )
    dest.write_text(html)
    print(f"Wrote {dest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
