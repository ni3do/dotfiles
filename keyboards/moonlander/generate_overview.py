#!/usr/bin/env python3
"""Generate a self-contained HTML overview from oryx-layout.json.

The JSON is kept in sync with the QMK source in qmk/, which is the master copy
once local edits diverge from Oryx.

After regenerating index.html, publish it to the existing Artifact Publisher
page (see artifact.json and README.md) with update_artifact so the share link
stays the same.
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

# Flip `flashed` to a datetime after the board is updated, e.g. "18 Nov 2026, 10:52 CET".
# Leave it as None to show "flash pending". Can also be overridden by a
# top-level "firmware" object in oryx-layout.json.
FIRMWARE = {
    "built": "18 Nov",
    "flashed": None,
}

LAYER_COLORS = {
    0: "#8839EF",  # Catppuccin Latte Mauve — darker Base
    1: "#A6E3A1",  # Mocha Green
    2: "#74C7EC",  # Mocha Sapphire
    3: "#F38BA8",  # Mocha Red (pink)
    4: "#D20F39",  # Latte Red (true red)
}

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
LEFT_COLS = list(zip(*LEFT_ROWS))
RIGHT_COLS = list(zip(*RIGHT_ROWS))
LEFT_THUMBS = [33, 34, 35]
RIGHT_THUMBS = [69, 70, 71]
LEFT_CLUSTER = 32
RIGHT_CLUSTER = 68
THUMB_INDICES = LEFT_THUMBS + RIGHT_THUMBS + [LEFT_CLUSTER, RIGHT_CLUSTER]

# Column stagger as a fraction of key size, pinky → inner (downward).
COL_STAGGER = (0.42, 0.15, 0.00, 0.18, 0.40)

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
    "KC_MS_BTN1": "LMB",
    "KC_MS_BTN3": "MMB",
    "KC_MS_BTN2": "RMB",
    "QK_BOOT": "Boot",
    "KC_MS_LEFT": "Ms ←",
    "KC_MS_DOWN": "Ms ↓",
    "KC_MS_UP": "Ms ↑",
    "KC_MS_RIGHT": "Ms →",
    "KC_MS_WH_LEFT": "Wh ←",
    "KC_MS_WH_DOWN": "Wh ↓",
    "KC_MS_WH_UP": "Wh ↑",
    "KC_MS_WH_RIGHT": "Wh →",
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

WRAP_LABELS = {
    "Ctrl+Space": "Ctrl+\nSpace",
    "Caps Word": "Caps\nWord",
    "Win+←": "Win\nLeft",
    "Win+→": "Win\nRight",
    "Win+↑": "Win\nUp",
    "Win+↓": "Win\nDown",
    "Ms ←": "Ms\nLeft",
    "Ms ↓": "Ms\nDown",
    "Ms ↑": "Ms\nUp",
    "Ms →": "Ms\nRight",
    "Wh ←": "Wh\nLeft",
    "Wh ↓": "Wh\nDown",
    "Wh ↑": "Wh\nUp",
    "Wh →": "Wh\nRight",
}


def esc(text: str) -> str:
    return (
        text.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', "&quot;")
    )


def layout_root(data: dict) -> tuple[dict, dict]:
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
            return f"{local.day} {local.strftime('%b %Y, %H:%M CET')}"
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


def slug(name: str) -> str:
    return "".join(ch for ch in name.lower() if ch.isalnum())


def render_key(
    state: dict,
    *,
    cluster: bool = False,
    activator_for: str | None = None,
) -> str:
    kind = state["kind"]
    classes = ["key"]
    if cluster:
        classes.append("cluster")
    if activator_for:
        classes.append("activator")
    attrs = []
    if activator_for:
        attrs.append(f'data-opens="{esc(slug(activator_for))}"')
        title = state.get("title") or f"Hold for {activator_for}"
        attrs.append(f'title="{esc(title)}"')
    if kind == "empty":
        classes.append("empty")
        if not activator_for:
            attrs.append('aria-hidden="true"')
        else:
            classes.append("activator-empty")
            inner = f'<span class="hold hold-layer-{esc(slug(activator_for))}">{esc(activator_for)}</span>'
            return f'<div class="{" ".join(classes)}" {" ".join(attrs)}>{inner}</div>'
        return f'<div class="{" ".join(classes)}" {" ".join(attrs)}></div>'
    if kind == "trans":
        classes.append("trans")
        attrs.append(f'title="{esc(state["title"])}"')
        return (
            f'<div class="{" ".join(classes)}" {" ".join(attrs)}>'
            '<span class="tap trans-mark">▽</span></div>'
        )
    classes.append("used")
    if state.get("hold"):
        classes.append("has-hold")
    if state.get("hold_layer"):
        attrs.append(f'data-opens="{esc(slug(state["hold_layer"]))}"')
    if state.get("title"):
        attrs.append(f'title="{esc(state["title"])}"')
    tap = state.get("tap") or ""
    visual = WRAP_LABELS.get(tap, tap)
    long_class = " long" if "\n" in visual or len(tap) >= 6 else ""
    parts = [f'<div class="{" ".join(classes)}" {" ".join(attrs)}>']
    parts.append(f'<span class="tap{long_class}">{esc(visual)}</span>')
    if state.get("hold"):
        hold_slug = slug(state["hold"]) if state.get("hold_layer") else ""
        hold_class = f" hold-layer-{esc(hold_slug)}" if hold_slug else ""
        parts.append(f'<span class="hold{hold_class}">{esc(state["hold"])}</span>')
    parts.append("</div>")
    return "".join(parts)


def key_at(keys: list, idx: int, layer_names: dict[int, str]) -> dict:
    return key_state(keys[idx] if idx < len(keys) else None, layer_names)


def render_columns(
    keys: list,
    cols: list[tuple[int, ...]],
    layer_names: dict[int, str],
    activators: dict[int, str],
) -> str:
    out = ['<div class="well">']
    for i, col in enumerate(cols):
        stagger = COL_STAGGER[i] if i < len(COL_STAGGER) else 0
        out.append(f'<div class="col" style="--stagger:{stagger}">')
        for idx in col:
            out.append(render_key(key_at(keys, idx, layer_names), activator_for=activators.get(idx)))
        out.append("</div>")
    out.append("</div>")
    return "".join(out)


def firmware_line(fw: dict) -> tuple[str, bool]:
    built = fw.get("built") or "unknown"
    flashed = fw.get("flashed")
    if flashed:
        return f"Flashed {flashed}", False
    return f"Firmware built {built} · flash pending", True


def settings_card(config: dict, layers: list[dict]) -> str:
    rows: list[tuple[str, str]] = []
    term = config.get("tappingTerm")
    per_key = []
    if layers and config.get("perKeyTappingTerm"):
        names = {17: "D", 18: "F"}
        for i, key in enumerate(layers[0].get("keys") or []):
            t = (key or {}).get("tappingTerm")
            if t:
                per_key.append(f"{names.get(i, f'#{i}')} at {t} ms")
    if term is not None:
        value = f"{term} ms"
        if per_key:
            # "D and F at 160 ms" when they share a term
            names_only = [s.split(" at ")[0] for s in per_key]
            terms_only = {s.split(" at ")[-1] for s in per_key}
            if len(terms_only) == 1:
                value += " · " + " and ".join(names_only) + " at " + terms_only.pop()
            else:
                value += " · " + " · ".join(per_key)
        rows.append(("Tapping term", value))
    holds = []
    if config.get("permissiveHold"):
        holds.append("Permissive hold")
    if config.get("chordalHold"):
        extra = ", thumbs excluded" if config.get("chordalHoldExcludeThumbs") else ""
        holds.append("Chordal hold" + extra)
    if holds:
        rows.append(("Holds", " · ".join(holds)))
    timeout = config.get("rgbTimeout")
    if timeout is not None:
        rows.append(("RGB timeout", f"{timeout} min"))
    items = []
    for label, value in rows:
        items.append(
            f'<div class="setting"><span class="sk">{esc(label)}</span>'
            f'<span class="sv">{esc(value)}</span></div>'
        )
    return '<aside class="settings-card">' + "".join(items) + "</aside>"


def lighting_card() -> str:
    items = [
        (
            "Ripple",
            "Each keypress sends a Rosewater cream wave. Keys just behind the front dim briefly so the ripple reads even when the layer is already at full brightness.",
        ),
        (
            "Mods & Caps Word",
            "A held home-row mod lights that key and its mirror in rosewater cream. Caps Word pulses the letter keys in Mocha Yellow.",
        ),
        (
            "All keys",
            "Every key lights in the active layer colour at full brightness (the board's 175 cap), including unmapped and transparent keys.",
        ),
        (
            "Status LEDs",
            "Both halves match by colour: blue = Num (LED 1 and 4), green = Sym (LED 2 and 5), red = Nav (LED 3 and 6). All six light on Fn. All off on Base. Caps Word stays on the key LEDs only.",
        ),
    ]
    rows = []
    for label, text in items:
        rows.append(
            f'<div class="setting"><span class="sk">{esc(label)}</span>'
            f'<span class="sv">{esc(text)}</span></div>'
        )
    return (
        '<aside class="settings-card lighting-card" aria-label="Lighting">'
        '<p class="card-title">Lighting</p>'
        + "".join(rows)
        + "</aside>"
    )


def legend_html(layer_names: dict[int, str], layers: list[dict]) -> str:
    base = (layers[0].get("keys") if layers else []) or []
    groups: dict[str, list[str]] = {}
    order: list[str] = []
    for idx, fallback in (
        (33, "Tab"),
        (71, "Space"),
        (34, "Bksp"),
        (35, "Esc"),
        (69, "Del"),
        (70, "Enter"),
    ):
        state = key_at(base, idx, layer_names)
        tap = state.get("tap") or fallback
        hold = state.get("hold")
        if not hold:
            continue
        if hold not in groups:
            groups[hold] = []
            order.append(hold)
        groups[hold].append(tap)
    items = []
    for hold in order:
        taps = groups[hold]
        color = LAYER_COLORS.get(next((i for i, n in layer_names.items() if n == hold), None), "#888")
        if len(taps) == 1:
            trigger = taps[0]
        else:
            trigger = " / ".join(taps)
        items.append(
            f'<span class="legend-item" data-opens="{esc(slug(hold))}">'
            f'<span class="swatch" style="background:{color}"></span>'
            f'<span class="legend-keys">{esc(trigger)}</span>'
            f'<span class="legend-arrow">→</span>'
            f'<span class="legend-layer">{esc(hold)}</span></span>'
        )
    return "".join(items)


def layer_hint(idx: int, title: str, layers: list[dict], layer_names: dict[int, str]) -> str:
    if idx != 0:
        base = (layers[0].get("keys") if layers else []) or []
        holders = []
        for i, fallback in ((33, "Tab"), (34, "Bksp"), (35, "Esc"), (69, "Del"), (70, "Enter"), (71, "Space")):
            st = key_at(base, i, layer_names)
            if st.get("hold") == title:
                holders.append(st.get("tap") or fallback)
        if holders:
            if len(holders) == 1:
                return f"Hold {holders[0]}"
            return "Hold " + " or ".join(holders)
        return ""
    return "Home-row mods on A S D F and J K L ;"


def activator_map(base_keys: list, layer_names: dict[int, str]) -> dict[int, str]:
    found: dict[int, str] = {}
    for i in THUMB_INDICES:
        st = key_at(base_keys, i, layer_names)
        if st.get("hold_layer"):
            found[i] = st["hold_layer"]
    return found


def build_layer(
    idx: int,
    layer: dict,
    layers: list[dict],
    layer_names: dict[int, str],
    activators: dict[int, str],
) -> str:
    title = layer.get("title") or layer_names[idx]
    name = slug(title)
    color = layer.get("color") or LAYER_COLORS.get(idx, "#888")
    keys = layer.get("keys") or []
    hint = layer_hint(idx, title, layers, layer_names)
    # Only mark activators on the layer they open.
    layer_activators = {i: n for i, n in activators.items() if n == title}
    left_well = render_columns(keys, LEFT_COLS, layer_names, layer_activators)
    right_well = render_columns(keys, RIGHT_COLS, layer_names, layer_activators)
    left_thumbs = "".join(
        render_key(key_at(keys, i, layer_names), activator_for=layer_activators.get(i))
        for i in LEFT_THUMBS
    )
    right_thumbs = "".join(
        render_key(key_at(keys, i, layer_names), activator_for=layer_activators.get(i))
        for i in RIGHT_THUMBS
    )
    left_cluster = render_key(
        key_at(keys, LEFT_CLUSTER, layer_names),
        cluster=True,
        activator_for=layer_activators.get(LEFT_CLUSTER),
    )
    right_cluster = render_key(
        key_at(keys, RIGHT_CLUSTER, layer_names),
        cluster=True,
        activator_for=layer_activators.get(RIGHT_CLUSTER),
    )
    hint_html = f'<span class="hint">{esc(hint)}</span>' if hint else ""
    return f"""
    <section class="layer" data-layer="{esc(name)}" data-index="{idx}" data-title="{esc(title)}" style="--layer-accent:{color}">
      <h2><span class="layer-dot"></span><span class="layer-name">{esc(title)}</span> {hint_html}</h2>
      <div class="board">
        <div class="half left">
          <div class="case">
            {left_well}
            <div class="thumb-cluster">
              <div class="thumb-keys">{left_thumbs}</div>
              <div class="cluster-slot">{left_cluster}</div>
            </div>
          </div>
        </div>
        <div class="half right">
          <div class="case">
            {right_well}
            <div class="thumb-cluster">
              <div class="cluster-slot">{right_cluster}</div>
              <div class="thumb-keys">{right_thumbs}</div>
            </div>
          </div>
        </div>
      </div>
    </section>
    """


def fill(template: str, **values: str) -> str:
    out = template
    for key, value in values.items():
        out = out.replace("[[" + key + "]]", value)
    return out

TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Moonlander layout · [[title]]</title>
<script>
(function () {
  try {
    var t = new URLSearchParams(location.search).get("theme");
    if (t === "dark" || t === "light") document.documentElement.setAttribute("data-theme", t);
  } catch (e) {}
})();
</script>
<style>
  :root {
    --bg: #efe8dc;
    --bg-glow: #e6dfd2;
    --ink: #1b2430;
    --ink-soft: #3d4754;
    --muted: #6d746c;
    --line: #d5cec2;
    --surface: #f7f3eb;
    --plate: #dcd6cb;
    --plate-hi: #e6e0d5;
    --plate-edge: #c6bfb3;
    --cap: #f3efe6;
    --cap-top: #fbf8f2;
    --cap-edge: #cfc8bb;
    --cap-shadow: #b7b0a3;
    --cap-ink: #1b2430;
    --cap-empty: #e5dfd3;
    --cap-empty-ink: #a8a196;
    --cap-sheen: rgba(255,255,255,.62);
    --cap-inset: rgba(28,36,48,.05);
    --shadow: rgba(28,36,48,.10);
    --cluster-rim: #7a3e3e;
    --status-pending: #8a5a20;
    --mauve: #8839EF;
    --sym: #40A02B;
    --num: #209FB5;
    --nav: #C4476A;
    --fn: #D20F39;
    --mauve-dot: #8839EF;
    --sym-dot: #A6E3A1;
    --num-dot: #74C7EC;
    --nav-dot: #F38BA8;
    --fn-dot: #D20F39;
    --key: 54px;
    --gap: 7px;
    --sans: ui-sans-serif, system-ui, -apple-system, "Segoe UI", "Helvetica Neue", sans-serif;
    --serif: "Iowan Old Style", "Palatino Linotype", Palatino, Georgia, "Times New Roman", serif;
    --mono: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
  }
  @media (prefers-color-scheme: dark) {
    :root:not([data-theme="light"]),
    html[data-theme="dark"] {
      --bg: #12151b;
      --bg-glow: #1a1e28;
      --ink: #eee8dc;
      --ink-soft: #c7c1b6;
      --muted: #8d928a;
      --line: #2c323c;
      --surface: #1a1e26;
      --plate: #161a21;
      --plate-hi: #1c2129;
      --plate-edge: #262c36;
      --cap: #2b313b;
      --cap-top: #353c47;
      --cap-edge: #1a1e24;
      --cap-shadow: #0a0c10;
      --cap-ink: #f2ece0;
      --cap-empty: #1d222a;
      --cap-empty-ink: #5c6370;
      --cap-sheen: rgba(255,255,255,.07);
      --cap-inset: rgba(0,0,0,.22);
      --shadow: rgba(0,0,0,.35);
      --cluster-rim: #a35656;
      --status-pending: #e0b060;
      --mauve: #CBA6F7;
      --sym: #A6E3A1;
      --num: #74C7EC;
      --nav: #F38BA8;
      --fn: #D20F39;
    }
  }
  html[data-theme="dark"] {
    --bg: #12151b;
    --bg-glow: #1a1e28;
    --ink: #eee8dc;
    --ink-soft: #c7c1b6;
    --muted: #8d928a;
    --line: #2c323c;
    --surface: #1a1e26;
    --plate: #161a21;
    --plate-hi: #1c2129;
    --plate-edge: #262c36;
    --cap: #2b313b;
    --cap-top: #353c47;
    --cap-edge: #1a1e24;
    --cap-shadow: #0a0c10;
    --cap-ink: #f2ece0;
    --cap-empty: #1d222a;
    --cap-empty-ink: #5c6370;
    --cap-sheen: rgba(255,255,255,.07);
    --cap-inset: rgba(0,0,0,.22);
    --shadow: rgba(0,0,0,.35);
    --cluster-rim: #a35656;
    --status-pending: #e0b060;
    --mauve: #CBA6F7;
    --sym: #A6E3A1;
    --num: #74C7EC;
    --nav: #F38BA8;
    --fn: #D20F39;
    color-scheme: dark;
  }
  html[data-theme="light"] { color-scheme: light; }
  * { box-sizing: border-box; }
  html { color-scheme: light dark; }
  html, body { margin: 0; padding: 0; }
  body {
    font-family: var(--sans);
    color: var(--ink);
    background:
      radial-gradient(900px 420px at 50% -8%, var(--bg-glow), transparent 70%),
      var(--bg);
    line-height: 1.45;
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
  }
  a { color: var(--mauve); text-decoration: none; }
  a:hover { text-decoration: underline; }
  .wrap {
    max-width: 1100px;
    margin: 0 auto;
    padding: 48px 24px 96px;
  }
  .masthead {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 24px 40px;
    flex-wrap: wrap;
    margin-bottom: 28px;
  }
  .eyebrow {
    margin: 0 0 4px;
    font-size: .7rem;
    font-weight: 600;
    letter-spacing: .18em;
    text-transform: uppercase;
    color: var(--muted);
  }
  h1 {
    margin: 0;
    font-family: var(--serif);
    font-weight: 600;
    font-size: 2.35rem;
    letter-spacing: -.03em;
    line-height: 1.05;
    color: var(--ink);
  }
  .mast-meta { text-align: right; }
  .status {
    margin: 0 0 4px;
    font-size: .84rem;
    font-weight: 550;
    color: var(--status-pending);
    letter-spacing: .01em;
  }
  .status[data-pending="false"] { color: var(--muted); font-weight: 500; }
  .rev {
    margin: 0;
    color: var(--muted);
    font-size: .8rem;
  }
  .rev .sep { margin: 0 .45em; opacity: .55; }
  .settings-card {
    display: flex;
    flex-wrap: wrap;
    gap: 6px 28px;
    padding: 14px 18px;
    background: var(--surface);
    border: 1px solid var(--line);
    border-radius: 14px;
    margin: 0 0 14px;
  }
  .lighting-card { gap: 12px 24px; margin: 0 0 22px; }
  .card-title {
    flex: 1 0 100%;
    margin: 0 0 2px;
    font-size: .65rem;
    font-weight: 600;
    letter-spacing: .12em;
    text-transform: uppercase;
    color: var(--muted);
  }
  .lighting-card .setting { min-width: 200px; flex: 1 1 220px; }
  .lighting-card .sv { font-size: .84rem; }
  .setting { display: flex; flex-direction: column; gap: 1px; min-width: 160px; }
  .sk {
    font-size: .65rem;
    font-weight: 600;
    letter-spacing: .12em;
    text-transform: uppercase;
    color: var(--muted);
  }
  .sv { font-size: .9rem; color: var(--ink-soft); }
  .tabs {
    display: flex;
    flex-wrap: wrap;
    gap: 4px;
    margin: 0 0 16px;
    padding: 4px;
    background: var(--surface);
    border: 1px solid var(--line);
    border-radius: 12px;
    width: fit-content;
    max-width: 100%;
  }
  .tabs button {
    appearance: none;
    background: transparent;
    color: var(--ink-soft);
    border: 0;
    border-radius: 8px;
    padding: 7px 13px;
    font: inherit;
    font-size: .86rem;
    font-weight: 550;
    cursor: pointer;
    position: relative;
    transition: background .15s ease, color .15s ease;
  }
  .tabs button:hover { color: var(--ink); background: color-mix(in srgb, var(--bg) 65%, transparent); }
  .tabs button:focus-visible {
    outline: 2px solid var(--ink);
    outline-offset: 2px;
  }
  .tabs button[aria-selected="true"] {
    background: var(--bg);
    color: var(--ink);
    box-shadow: 0 1px 2px var(--shadow);
  }
  .tabs button .dot {
    display: inline-block;
    width: .48em;
    height: .48em;
    border-radius: 50%;
    margin-right: .4em;
    vertical-align: 1px;
    background: var(--tab-dot, var(--muted));
  }
  .tabs button[data-layer="base"] { --tab-dot: var(--mauve-dot); --tab-accent: var(--mauve); }
  .tabs button[data-layer="sym"] { --tab-dot: var(--sym-dot); --tab-accent: var(--sym); }
  .tabs button[data-layer="num"] { --tab-dot: var(--num-dot); --tab-accent: var(--num); }
  .tabs button[data-layer="nav"] { --tab-dot: var(--nav-dot); --tab-accent: var(--nav); }
  .tabs button[data-layer="fn"] { --tab-dot: var(--fn-dot); --tab-accent: var(--fn); }
  body[data-hover-layer] .tabs button[data-layer] {
    opacity: .55;
  }
  body[data-hover-layer] .tabs button[aria-selected="true"],
  body[data-hover-layer="sym"] .tabs button[data-layer="sym"],
  body[data-hover-layer="num"] .tabs button[data-layer="num"],
  body[data-hover-layer="nav"] .tabs button[data-layer="nav"],
  body[data-hover-layer="fn"] .tabs button[data-layer="fn"],
  body[data-hover-layer="base"] .tabs button[data-layer="base"] {
    opacity: 1;
    box-shadow: 0 0 0 2px var(--tab-accent, var(--ink));
  }
  .legend {
    display: flex;
    flex-wrap: wrap;
    gap: 8px 18px;
    margin: 0 0 22px;
    font-size: .82rem;
    color: var(--ink-soft);
  }
  .legend-item { display: inline-flex; align-items: center; gap: 6px; }
  .legend-keys { font-weight: 550; color: var(--ink); }
  .legend-arrow { color: var(--muted); font-size: .75rem; }
  .legend-layer { font-weight: 550; }
  .swatch {
    display: inline-block;
    width: .55em;
    height: .55em;
    border-radius: 50%;
    flex: none;
  }
  body.single .layer { display: none; }
  body.single .layer.is-active { display: block; }
  body.view-all .layers { display: flex; flex-direction: column; gap: 18px; }
  body[data-hover-layer] .view-all .layer { opacity: .55; transition: opacity .15s ease; }
  body.view-all[data-hover-layer="base"] .layer[data-layer="base"],
  body.view-all[data-hover-layer="sym"] .layer[data-layer="sym"],
  body.view-all[data-hover-layer="num"] .layer[data-layer="num"],
  body.view-all[data-hover-layer="nav"] .layer[data-layer="nav"],
  body.view-all[data-hover-layer="fn"] .layer[data-layer="fn"] {
    opacity: 1;
  }
  .layer {
    background: var(--surface);
    border: 1px solid var(--line);
    border-radius: 20px;
    padding: 18px 16px 8px;
    --layer-pretty: var(--mauve);
  }
  .layer[data-layer="sym"] { --layer-pretty: var(--sym); }
  .layer[data-layer="num"] { --layer-pretty: var(--num); }
  .layer[data-layer="nav"] { --layer-pretty: var(--nav); }
  .layer[data-layer="fn"] { --layer-pretty: var(--fn); }
  .layer h2 {
    margin: 0 0 6px;
    padding: 0 8px;
    font-size: 1rem;
    font-weight: 600;
    display: flex;
    align-items: baseline;
    gap: 8px;
    letter-spacing: -.01em;
  }
  .layer-dot {
    width: .5em;
    height: .5em;
    border-radius: 50%;
    background: var(--layer-accent);
    flex: none;
    transform: translateY(-1px);
  }
  .layer-name { color: var(--ink); }
  .hint {
    color: var(--muted);
    font-size: .8rem;
    font-weight: 500;
    letter-spacing: 0;
  }
  .board {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    gap: 44px;
    padding: 24px 8px 28px;
    overflow: visible;
  }
  .half { flex: none; }
  .half.left { transform: rotate(6.5deg); transform-origin: 70% 55%; }
  .half.right { transform: rotate(-6.5deg); transform-origin: 30% 55%; }
  .case {
    background: linear-gradient(180deg, var(--plate-hi), var(--plate) 45%, var(--plate-edge));
    border-radius: 26px 26px 34px 34px;
    padding: 22px 20px 62px;
    box-shadow:
      inset 0 1px 0 rgba(255,255,255,.28),
      inset 0 -1px 0 rgba(0,0,0,.06),
      0 14px 32px var(--shadow);
  }
  .well {
    display: flex;
    gap: var(--gap);
    align-items: flex-start;
  }
  .col {
    display: flex;
    flex-direction: column;
    gap: var(--gap);
    transform: translateY(calc(var(--stagger) * var(--key)));
  }
  .thumb-cluster {
    display: flex;
    align-items: flex-end;
    justify-content: flex-end;
    margin-top: 44px;
    min-height: calc(var(--key) * 1.7);
  }
  .half.right .thumb-cluster { justify-content: flex-start; }
  .thumb-keys {
    display: flex;
    gap: var(--gap);
    transform: rotate(24deg);
    transform-origin: 80% 20%;
  }
  .half.right .thumb-keys {
    transform: rotate(-24deg);
    transform-origin: 20% 20%;
  }
  .cluster-slot {
    margin: 0 2px 40px 8px;
  }
  .half.left .cluster-slot { margin: 0 8px 40px 2px; }
  .key {
    width: var(--key);
    height: var(--key);
    border-radius: 9px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    position: relative;
    user-select: none;
    padding: 4px 3px 5px;
    flex: none;
    transition: transform .15s ease, box-shadow .15s ease;
  }
  .key.used {
    background: linear-gradient(180deg, var(--cap-top) 0%, var(--cap) 42%, var(--cap) 100%);
    color: var(--cap-ink);
    border: 1px solid var(--cap-edge);
    box-shadow:
      inset 0 1px 0 var(--cap-sheen),
      inset 0 -2px 3px var(--cap-inset),
      0 3px 0 var(--cap-shadow),
      0 7px 14px var(--shadow);
  }
  .key.empty {
    background: var(--cap-empty);
    border: 1px solid transparent;
    box-shadow: inset 0 1px 0 rgba(255,255,255,.12), 0 1px 0 var(--plate-edge);
  }
  .key.trans {
    background: var(--cap-empty);
    border: 1px dashed var(--cap-edge);
    color: var(--cap-empty-ink);
    box-shadow: none;
  }
  .key.cluster {
    width: calc(var(--key) - 4px);
    height: calc(var(--key) - 4px);
    border-radius: 46%;
  }
  .key.cluster.used {
    box-shadow:
      inset 0 1px 0 var(--cap-sheen),
      inset 0 -2px 3px var(--cap-inset),
      0 0 0 2px var(--cluster-rim),
      0 3px 0 var(--cap-shadow),
      0 7px 14px var(--shadow);
  }
  .key.activator, .key.activator-empty {
    box-shadow:
      inset 0 1px 0 var(--cap-sheen),
      0 0 0 2px var(--layer-pretty),
      0 3px 0 var(--cap-shadow);
  }
  .key.activator-empty {
    background: color-mix(in srgb, var(--layer-pretty) 14%, var(--cap-empty));
    border: 1px solid transparent;
    color: var(--layer-pretty);
  }
  .key.has-hold, .key[data-opens] { cursor: pointer; }
  .key.used:hover, .key[data-opens]:hover {
    transform: translateY(-1px);
  }
  body[data-hover-layer="sym"] .key[data-opens="sym"],
  body[data-hover-layer="num"] .key[data-opens="num"],
  body[data-hover-layer="nav"] .key[data-opens="nav"],
  body[data-hover-layer="fn"] .key[data-opens="fn"] {
    box-shadow:
      inset 0 1px 0 var(--cap-sheen),
      0 0 0 2px var(--tab-accent, var(--layer-pretty)),
      0 4px 0 var(--cap-shadow),
      0 10px 18px var(--shadow);
  }
  .tap {
    font-weight: 600;
    font-size: .92rem;
    letter-spacing: -.01em;
    line-height: 1.15;
    white-space: pre-line;
  }
  .tap.long { font-size: .68rem; font-weight: 600; letter-spacing: 0; }
  .tap.trans-mark { font-weight: 400; font-size: .9rem; }
  .key.has-hold .tap { margin-top: -1px; }
  .hold {
    margin-top: 3px;
    font-size: .58rem;
    font-weight: 650;
    letter-spacing: .06em;
    text-transform: uppercase;
    line-height: 1;
    color: var(--muted);
  }
  .hold-layer-sym { color: var(--sym); }
  .hold-layer-num { color: var(--num); }
  .hold-layer-nav { color: var(--nav); }
  .hold-layer-fn { color: var(--fn); }
  .hold-layer-base { color: var(--mauve); }
  .note, footer {
    margin: 8px 0 0;
    color: var(--muted);
    font-size: .78rem;
    text-align: center;
  }
  footer { margin-top: 14px; }
  footer .mono { font-family: var(--mono); font-size: .92em; white-space: nowrap; }
  @media (max-width: 860px) {
    :root { --key: 46px; --gap: 6px; }
    .board { gap: 28px; padding: 22px 0 36px; }
    h1 { font-size: 1.9rem; }
    .mast-meta { text-align: left; }
  }
  @media (max-width: 620px) {
    :root { --key: 44px; }
    .board {
      flex-direction: column;
      align-items: center;
      gap: 12px;
      padding-bottom: 20px;
    }
    .half.left, .half.right { transform: none; }
    .wrap { padding: 32px 16px 88px; }
  }
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after { transition: none !important; }
  }
  @media print {
    body { background: #fff; color: #111; }
    .tabs { display: none; }
    body.single .layer { display: block !important; }
    .layer { break-inside: avoid; border-color: #ccc; background: #fff; box-shadow: none; }
    .wrap { padding-bottom: 24px; }
  }
</style>
</head>
<body>
  <div class="wrap">
    <header class="masthead">
      <div class="brand">
        <p class="eyebrow">ZSA Moonlander</p>
        <h1>[[title]]</h1>
      </div>
      <div class="mast-meta">
        <p class="status" data-pending="[[pending]]">[[firmware]]</p>
        <p class="rev">QMK [[qmk_version]]<span class="sep">·</span>[[created]]<span class="sep">·</span>rev <span class="mono">[[revision]]</span></p>
      </div>
    </header>
    [[settings]]
    [[lighting]]
    <div class="tabs" role="tablist" aria-label="Layers">
      <button type="button" role="tab" data-layer="all" aria-selected="false">Show all</button>
      [[tab_buttons]]
    </div>
    <div class="legend" aria-label="Thumb layer holds">
      [[legend]]
    </div>
    <div class="layers">
      [[layers]]
    </div>
    <p class="note">3×5+3 layout · unused outer columns omitted · inner round keys are the cluster keys</p>
    <footer>
      Master copy is <span class="mono">qmk/keymap.c</span>.[[local_note]]
    </footer>
  </div>
<script>
(function () {
  const buttons = Array.from(document.querySelectorAll(".tabs button"));
  const layers = Array.from(document.querySelectorAll(".layer"));
  const names = buttons.map((b) => b.dataset.layer);

  function show(id, updateHash) {
    const valid = names.includes(id) ? id : "base";
    document.body.classList.toggle("single", valid !== "all");
    document.body.classList.toggle("view-all", valid === "all");
    layers.forEach((el) => el.classList.toggle("is-active", el.dataset.layer === valid));
    buttons.forEach((btn) => {
      const on = btn.dataset.layer === valid;
      btn.setAttribute("aria-selected", String(on));
      btn.tabIndex = on ? 0 : -1;
    });
    if (updateHash) {
      history.replaceState(null, "", valid === "base" ? location.pathname + location.search : "#" + valid);
    }
  }

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => show(btn.dataset.layer, true));
  });

  document.querySelector(".tabs").addEventListener("keydown", (e) => {
    const i = buttons.indexOf(document.activeElement);
    if (i < 0) return;
    let next = -1;
    if (e.key === "ArrowRight" || e.key === "ArrowDown") next = (i + 1) % buttons.length;
    if (e.key === "ArrowLeft" || e.key === "ArrowUp") next = (i - 1 + buttons.length) % buttons.length;
    if (e.key === "Home") next = 0;
    if (e.key === "End") next = buttons.length - 1;
    if (next >= 0) {
      e.preventDefault();
      buttons[next].focus();
      show(buttons[next].dataset.layer, true);
    }
  });

  document.querySelectorAll("[data-opens]").forEach((el) => {
    el.addEventListener("pointerenter", () => {
      document.body.dataset.hoverLayer = el.dataset.opens;
    });
    el.addEventListener("pointerleave", () => {
      delete document.body.dataset.hoverLayer;
    });
    el.addEventListener("click", () => show(el.dataset.opens, true));
  });

  const raw = (location.hash || "#base").slice(1);
  show(raw || "base", false);
})();
</script>
</body>
</html>
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
    if data.get("sourceOfTruth") == "qmk" or data.get("localNote") or revision.get("localNote"):
        local_note = "Includes local edits not yet in Oryx."
    else:
        local_note = ""

    fw = data.get("firmware") or FIRMWARE
    firmware, pending = firmware_line(fw)
    base_keys = (layers[0].get("keys") if layers else []) or []
    activators = activator_map(base_keys, layer_names)

    sections = []
    for i, layer in enumerate(layers):
        sections.append(build_layer(i, layer, layers, layer_names, activators))

    tab_buttons = []
    for i, name in layer_names.items():
        tab_buttons.append(
            f'<button type="button" role="tab" data-layer="{esc(slug(name))}" aria-selected="false">'
            f'<span class="dot"></span>{esc(name)}</button>'
        )

    html = fill(
        TEMPLATE,
        title=esc(title),
        revision=esc(revision_id),
        created=esc(created),
        qmk_version=esc(str(qmk_version)),
        local_note=(" " + esc(local_note)) if local_note else "",
        settings=settings_card(config, layers),
        lighting=lighting_card(),
        legend=legend_html(layer_names, layers),
        tab_buttons="".join(tab_buttons),
        layers="".join(sections),
        firmware=esc(firmware),
        pending="true" if pending else "false",
    )
    dest.write_text(html)
    print(f"Wrote {dest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
