#include QMK_KEYBOARD_H
#include "version.h"
#define MOON_LED_LEVEL LED_LEVEL
#ifndef ZSA_SAFE_RANGE
#define ZSA_SAFE_RANGE SAFE_RANGE
#endif

enum custom_keycodes {
  RGB_SLD = ZSA_SAFE_RANGE,
};




const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,           KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_TRANSPARENT, 
    KC_TRANSPARENT, MT(MOD_LGUI, KC_A),MT(MOD_LALT, KC_S),MT(MOD_LSFT, KC_D),MT(MOD_LCTL, KC_F),KC_G,           KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_H,           MT(MOD_RCTL, KC_J),MT(MOD_RSFT, KC_K),MT(MOD_RALT, KC_L),MT(MOD_RGUI, KC_SCLN),KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_Z,           KC_X,           KC_C,           KC_V,           KC_B,                                           KC_N,           KC_M,           KC_COMMA,       KC_DOT,         KC_SLASH,       KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, LALT(LCTL(LSFT(KC_SPACE))),                                                                                                LCTL(KC_SPACE), KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    LT(1, KC_TAB),  LT(2, KC_BSPC), LT(3, KC_ESCAPE),                LT(3, KC_DELETE),LT(4, KC_ENTER),LT(1, KC_SPACE)
  ),
  [1] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_GRAVE,       KC_LBRC,        KC_RBRC,        KC_MINUS,       KC_EQUAL,       KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_BSLS,        KC_QUOTE,       KC_SCLN,        KC_LABK,        KC_RABK,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TILD,        KC_LCBR,        KC_RCBR,        KC_UNDS,        KC_PLUS,        KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_PIPE,        KC_DQUO,        KC_COLN,        KC_SLASH,       KC_QUES,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_EXLM,        KC_AT,          KC_HASH,        KC_DLR,         KC_PERC,                                        KC_CIRC,        KC_AMPR,        KC_ASTR,        KC_LPRN,        KC_RPRN,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_DOT,         KC_TRANSPARENT,                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [2] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_ASTR,        KC_7,           KC_8,           KC_9,           KC_SLASH,       KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,  KC_LEFT_CTRL,   KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_MINUS,       KC_4,           KC_5,           KC_6,           KC_PLUS,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_EQUAL,       KC_1,           KC_2,           KC_3,           KC_DOT,         KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_COMMA,       KC_ENTER,       KC_0
  ),
  [3] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_HOME,        KC_PGDN,        KC_PAGE_UP,     KC_END,         KC_DELETE,      KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_LEFT_GUI,    KC_LEFT_ALT,    KC_LEFT_SHIFT,  KC_LEFT_CTRL,   KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_LEFT,        KC_DOWN,        KC_UP,          KC_RIGHT,       CW_TOGG,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 LCTL(KC_Z),     LCTL(KC_X),     LCTL(KC_C),     LCTL(KC_V),     LCTL(KC_Y),     KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_PSCR,        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    LGUI(KC_UP),    LGUI(KC_DOWN),  KC_TRANSPARENT,                 LGUI(KC_LEFT),  LGUI(KC_RIGHT), LGUI(LSFT(KC_S))
  ),
  [4] = LAYOUT_moonlander(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_F12,         KC_F7,          KC_F8,          KC_F9,          KC_AUDIO_VOL_UP,KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_MS_BTN1,     KC_MS_BTN3,     KC_MS_BTN2,     QK_BOOT,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_F11,         KC_F4,          KC_F5,          KC_F6,          KC_AUDIO_VOL_DOWN,KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_MS_LEFT,     KC_MS_DOWN,     KC_MS_UP,       KC_MS_RIGHT,    KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_F10,         KC_F1,          KC_F2,          KC_F3,          KC_AUDIO_MUTE,                                  KC_MS_WH_LEFT,  KC_MS_WH_DOWN,  KC_MS_WH_UP,    KC_MS_WH_RIGHT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_MEDIA_PREV_TRACK,KC_MEDIA_PLAY_PAUSE,KC_MEDIA_NEXT_TRACK,                KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
};

const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM = LAYOUT(
  'L', 'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R', 'R',
  'L', 'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R', 'R',
  'L', 'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R', 'R',
  'L', 'L', 'L', 'L', 'L', 'L', 'R', 'R', 'R', 'R', 'R', 'R',
  'L', 'L', 'L', 'L', 'L', '*', '*', 'R', 'R', 'R', 'R', 'R',
                 '*', '*', '*', '*', '*', '*'
);


uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case MT(MOD_LSFT, KC_D):
            return TAPPING_TERM -30;
        case MT(MOD_LCTL, KC_F):
            return TAPPING_TERM -30;
        default:
            return TAPPING_TERM;
    }
}


extern rgb_config_t rgb_matrix_config;

/* Oryx layer paint table. Kept so Oryx/keycolors still have a symbol; hues
 * are also the source for the custom lighting below (LED 1 is a used key on
 * every layer in this map). */
const uint8_t PROGMEM ledmap[][RGB_MATRIX_LED_COUNT][3] = {
    [0] = { {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {0,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {0,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255} },

    [1] = { {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192} },

    [2] = { {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255} },

    [3] = { {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255} },

    [4] = { {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255} },

};

/* Catppuccin Mocha on the RGB matrix. Hex is the palette reference; HSV uses
 * a boosted saturation so the ISSI LEDs actually read as those hues (the
 * pastel hex sat would wash out). Base uses Latte Mauve #8839EF — a noticeably
 * darker mauve than Mocha Mauve #CBA6F7 — so the idle board is a dim tint,
 * not a bright violet. Value is applied per-key (bg / ripple / mods).
 *   Base  #8839EF  H=188 S=220
 *   Sym   #A6E3A1  H= 82 S=220
 *   Num   #74C7EC  H=141 S=220
 *   Nav   #FAB387  H= 16 S=220
 *   Fn    #F38BA8  H=243 S=220
 *   Mods  #F5E0DC  rosewater cream  H=7 S=50
 *   Caps  #F9E2AF  yellow           H=29 S=180
 */
enum {
    RIPPLE_COUNT = 8,
    RIPPLE_MS    = 450,
    RIPPLE_MIN_R = 10,
    RIPPLE_MAX_R = 56,
    BASE_BG_VAL  = 120,
    LAYER_BG_VAL = 255,
};

typedef struct {
    uint8_t  x;
    uint8_t  y;
    uint8_t  hue;
    uint8_t  sat;
    uint16_t start;
    bool     active;
} ripple_t;

static ripple_t ripples[RIPPLE_COUNT];
static uint8_t  cached_layer = 0;

extern bool is_launching;

static HSV layer_theme_hsv(uint8_t layer) {
    static const HSV themes[5] = {
        {188, 220, 255}, /* Base, darker mauve */
        {82,  220, 255}, /* Sym,  green        */
        {141, 220, 255}, /* Num,  sapphire     */
        {16,  220, 255}, /* Nav,  peach        */
        {243, 220, 255}, /* Fn,   red          */
    };
    if (layer > 4) {
        layer = 0;
    }
    /* Keep ledmap in the binary for Oryx; theme no longer reads from it. */
    (void)pgm_read_byte(&ledmap[0][0][0]);
    return themes[layer];
}

static uint8_t active_rgb_layer(void) {
    uint8_t layer = get_highest_layer(layer_state | default_layer_state);
    if (layer > 4) {
        layer = 0;
    }
    return layer;
}

static void sync_solid_color(uint8_t layer) {
    /* SOLID_COLOR is what you see if indicators are skipped; keep it on the
     * active layer hue at the hardware brightness cap (175 on Moonlander). */
    HSV theme = layer_theme_hsv(layer);
    rgb_matrix_sethsv_noeeprom(theme.h, theme.s, RGB_MATRIX_MAXIMUM_BRIGHTNESS);
}

static uint8_t scale_val(uint8_t v, uint8_t max) {
    return (uint8_t)((uint16_t)v * max / 255);
}

static void set_led_hsv(uint8_t led, uint8_t h, uint8_t s, uint8_t v) {
    uint8_t bright = rgb_matrix_config.hsv.v;
    if (bright < 80) {
        bright = RGB_MATRIX_MAXIMUM_BRIGHTNESS;
    }
    HSV hsv = {h, s, scale_val(v, bright)};
    RGB rgb = hsv_to_rgb(hsv);
    rgb_matrix_set_color(led, rgb.r, rgb.g, rgb.b);
}

static void update_status_leds(void) {
#ifdef COMMUNITY_MODULE_ORYX_ENABLE
    if (rawhid_state.status_led_control) {
        return;
    }
#endif
    if (!keyboard_config.led_level) {
        STATUS_LED_1(false);
        STATUS_LED_2(false);
        STATUS_LED_3(false);
        STATUS_LED_4(false);
        STATUS_LED_5(false);
        STATUS_LED_6(false);
        return;
    }
    uint8_t layer = active_rgb_layer();
    bool    caps  = is_caps_word_on() || host_keyboard_led_state().caps_lock;
    bool    led1  = false;
    bool    led2  = false;
    bool    led3  = false;
    switch (layer) {
        case 1:
            led1 = true;
            break;
        case 2:
            led2 = true;
            break;
        case 3:
            led3 = true;
            break;
        case 4:
            led1 = led2 = led3 = true;
            break;
        default:
            break;
    }
    if (caps) {
        led3 = true;
    }
    /* Left half = LED 1..3, right half = LED 4..6. Same pattern both sides. */
    STATUS_LED_1(led1);
    STATUS_LED_2(led2);
    STATUS_LED_3(led3);
    STATUS_LED_4(led1);
    STATUS_LED_5(led2);
    STATUS_LED_6(led3);
}

static uint16_t tap_keycode(uint16_t kc) {
    if (IS_QK_MOD_TAP(kc)) {
        return QK_MOD_TAP_GET_TAP_KEYCODE(kc);
    }
    if (IS_QK_LAYER_TAP(kc)) {
        return QK_LAYER_TAP_GET_TAP_KEYCODE(kc);
    }
    return kc;
}

static bool key_is_assigned(uint16_t kc) {
    return kc != KC_NO && kc != KC_TRANSPARENT;
}

static bool home_row_mod_held(uint16_t base_kc, uint8_t mods8) {
    if (!IS_QK_MOD_TAP(base_kc)) {
        return false;
    }
    uint8_t kind = QK_MOD_TAP_GET_MODS(base_kc) & 0x0F;
    return (((kind & MOD_LCTL) && (mods8 & MOD_MASK_CTRL)) ||
            ((kind & MOD_LSFT) && (mods8 & MOD_MASK_SHIFT)) ||
            ((kind & MOD_LALT) && (mods8 & MOD_MASK_ALT)) ||
            ((kind & MOD_LGUI) && (mods8 & MOD_MASK_GUI)));
}

static void start_ripple(keypos_t pos, uint8_t layer) {
    uint8_t led = g_led_config.matrix_co[pos.row][pos.col];
    if (led == NO_LED) {
        return;
    }
    int8_t   slot   = -1;
    uint16_t oldest = 0;
    for (uint8_t i = 0; i < RIPPLE_COUNT; i++) {
        if (!ripples[i].active) {
            slot = i;
            break;
        }
        uint16_t age = timer_elapsed(ripples[i].start);
        if (slot < 0 || age > oldest) {
            oldest = age;
            slot   = i;
        }
    }
    if (slot < 0) {
        return;
    }
    HSV theme            = layer_theme_hsv(layer);
    ripples[slot].x      = g_led_config.point[led].x;
    ripples[slot].y      = g_led_config.point[led].y;
    ripples[slot].hue    = theme.h;
    ripples[slot].sat    = theme.s;
    ripples[slot].start  = timer_read();
    ripples[slot].active = true;
}

static void expire_ripples(void) {
    for (uint8_t i = 0; i < RIPPLE_COUNT; i++) {
        if (ripples[i].active && timer_elapsed(ripples[i].start) > RIPPLE_MS) {
            ripples[i].active = false;
        }
    }
}

static void apply_ripple(uint8_t led, uint8_t *h, uint8_t *s, uint8_t *v) {
    uint8_t px = g_led_config.point[led].x;
    uint8_t py = g_led_config.point[led].y;
    for (uint8_t i = 0; i < RIPPLE_COUNT; i++) {
        if (!ripples[i].active) {
            continue;
        }
        uint16_t elapsed = timer_elapsed(ripples[i].start);
        if (elapsed > RIPPLE_MS) {
            continue;
        }
        uint8_t  fade   = 255 - (uint8_t)((uint32_t)elapsed * 255 / RIPPLE_MS);
        uint16_t radius = RIPPLE_MIN_R + (uint16_t)((uint32_t)elapsed * (RIPPLE_MAX_R - RIPPLE_MIN_R) / RIPPLE_MS);
        int16_t  dx     = (int16_t)px - ripples[i].x;
        int16_t  dy     = (int16_t)py - ripples[i].y;
        uint32_t dist2  = (uint32_t)(dx * dx) + (uint32_t)(dy * dy);
        uint32_t r2     = (uint32_t)radius * radius;
        if (dist2 >= r2) {
            continue;
        }
        uint8_t val = (uint8_t)((r2 - dist2) * fade / r2);
        if (val > *v) {
            *h = ripples[i].hue;
            *s = ripples[i].sat;
            *v = val;
        }
    }
}

void keyboard_post_init_user(void) {
    rgb_matrix_enable_noeeprom();
    rgb_matrix_set_flags(LED_FLAG_ALL);
    keyboard_config.rgb_matrix_enable = true;
    rgb_matrix_mode_noeeprom(RGB_MATRIX_SOLID_COLOR);
    cached_layer = active_rgb_layer();
    sync_solid_color(cached_layer);
}

layer_state_t layer_state_set_user(layer_state_t state) {
    uint8_t layer = get_highest_layer(state | default_layer_state);
    if (layer > 4) {
        layer = 0;
    }
    cached_layer = layer;
    if (!rawhid_state.rgb_control) {
        sync_solid_color(layer);
    }
    return state;
}

void housekeeping_task_user(void) {
    /* If the boot chase stalls (right-half LEDs left on after case 5–8),
     * take over after 4s so Base can actually go dark. */
    if (is_launching && timer_read32() > 4000) {
        is_launching = false;
    }
    if (!is_launching) {
        update_status_leds();
    }
}

void caps_word_set_user(bool active) {
    (void)active;
    if (!is_launching) {
        update_status_leds();
    }
}

bool rgb_matrix_indicators_user(void) {
    if (rawhid_state.rgb_control) {
        return false;
    }
    expire_ripples();
    return true;
}

bool rgb_matrix_indicators_advanced_user(uint8_t led_min, uint8_t led_max) {
    if (rawhid_state.rgb_control) {
        return false;
    }
    if (rgb_matrix_get_flags() == LED_FLAG_NONE) {
        for (uint8_t led = led_min; led < led_max; led++) {
            rgb_matrix_set_color(led, 0, 0, 0);
        }
        return true;
    }

    /* Use the cached highest layer from layer_state_set_user, and re-read
     * live state so a missed hook cannot leave the board stuck on Base. */
    uint8_t layer = active_rgb_layer();
    cached_layer  = layer;
    const HSV     theme = layer_theme_hsv(layer);
    const uint8_t bg_v  = (layer == 0) ? BASE_BG_VAL : LAYER_BG_VAL;
    const uint8_t mods  = get_mods() | get_oneshot_mods() | get_weak_mods();
    const bool    caps  = is_caps_word_on();
    uint8_t       cap_t = (uint8_t)(timer_read() >> 2);
    uint8_t       cap_tri = (cap_t < 128) ? (uint8_t)(cap_t * 2) : (uint8_t)((255 - cap_t) * 2);
    const uint8_t caps_v  = 150 + scale_val(cap_tri, 105);

    for (uint8_t row = 0; row < MATRIX_ROWS; row++) {
        for (uint8_t col = 0; col < MATRIX_COLS; col++) {
            uint8_t led = g_led_config.matrix_co[row][col];
            if (led == NO_LED || led < led_min || led >= led_max) {
                continue;
            }
            keypos_t pos     = {.row = row, .col = col};
            uint16_t kc      = keymap_key_to_keycode(layer, pos);
            uint16_t base_kc = keymap_key_to_keycode(0, pos);

            uint8_t h = 0, s = 0, v = 0;
            if (key_is_assigned(kc)) {
                h = theme.h;
                s = theme.s;
                v = bg_v;
            }
            apply_ripple(led, &h, &s, &v);

            uint16_t tap      = tap_keycode(base_kc);
            bool     is_alpha = (tap >= KC_A && tap <= KC_Z);
            bool     is_cw    = keymap_key_to_keycode(3, pos) == CW_TOGG;
            if (caps && (is_alpha || is_cw)) {
                h = 29;
                s = 180;
                v = caps_v;
            }
            if (home_row_mod_held(base_kc, mods)) {
                h = 7;
                s = 50;
                v = 255;
            }

            if (v == 0) {
                rgb_matrix_set_color(led, 0, 0, 0);
            } else {
                set_led_hsv(led, h, s, v);
            }
        }
    }
    return true;
}


bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  if (record->event.pressed && !rawhid_state.rgb_control) {
    uint8_t ripple_layer = active_rgb_layer();
    /* LT activates the layer after this hook, so colour the ripple for the
     * layer the key is about to enter. */
    if (IS_QK_LAYER_TAP(keycode)) {
        ripple_layer = QK_LAYER_TAP_GET_LAYER(keycode);
    }
    start_ripple(record->event.key, ripple_layer);
  }
  switch (keycode) {
  case QK_MODS ... QK_MODS_MAX:
    // Mouse and consumer keys (volume, media) with modifiers work inconsistently across operating systems,
    // this makes sure that modifiers are always applied to the key that was pressed.
    if (IS_MOUSE_KEYCODE(QK_MODS_GET_BASIC_KEYCODE(keycode)) || IS_CONSUMER_KEYCODE(QK_MODS_GET_BASIC_KEYCODE(keycode))) {
      if (record->event.pressed) {
        add_mods(QK_MODS_GET_MODS(keycode));
        send_keyboard_report();
        wait_ms(2);
        register_code(QK_MODS_GET_BASIC_KEYCODE(keycode));
        return false;
      } else {
        wait_ms(2);
        del_mods(QK_MODS_GET_MODS(keycode));
      }
    }
    break;

    case RGB_SLD:
        if (rawhid_state.rgb_control) {
            return false;
        }
        if (record->event.pressed) {
            rgblight_mode(1);
        }
        return false;
  }
  return true;
}

