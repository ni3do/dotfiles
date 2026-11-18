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

RGB hsv_to_rgb_with_value(HSV hsv) {
  RGB rgb = hsv_to_rgb( hsv );
  float f = (float)rgb_matrix_config.hsv.v / UINT8_MAX;
  return (RGB){ f * rgb.r, f * rgb.g, f * rgb.b };
}

void keyboard_post_init_user(void) {
  rgb_matrix_enable();
}

const uint8_t PROGMEM ledmap[][RGB_MATRIX_LED_COUNT][3] = {
    [0] = { {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {0,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {0,255,255}, {0,255,255}, {0,255,255}, {188,255,255}, {188,255,255}, {188,255,255}, {188,255,255} },

    [1] = { {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192}, {111,255,192} },

    [2] = { {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255}, {138,255,255} },

    [3] = { {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255}, {24,255,255} },

    [4] = { {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255}, {254,207,255} },

};

void set_layer_color(int layer) {
  for (int i = 0; i < RGB_MATRIX_LED_COUNT; i++) {
    HSV hsv = {
      .h = pgm_read_byte(&ledmap[layer][i][0]),
      .s = pgm_read_byte(&ledmap[layer][i][1]),
      .v = pgm_read_byte(&ledmap[layer][i][2]),
    };
    if (!hsv.h && !hsv.s && !hsv.v) {
        rgb_matrix_set_color( i, 0, 0, 0 );
    } else {
        RGB rgb = hsv_to_rgb_with_value(hsv);
        rgb_matrix_set_color(i, rgb.r, rgb.g, rgb.b);
    }
  }
}

bool rgb_matrix_indicators_user(void) {
  if (rawhid_state.rgb_control) {
      return false;
  }
  if (!keyboard_config.disable_layer_led) { 
    switch (biton32(layer_state)) {
      case 0:
        set_layer_color(0);
        break;
      case 1:
        set_layer_color(1);
        break;
      case 2:
        set_layer_color(2);
        break;
      case 3:
        set_layer_color(3);
        break;
      case 4:
        set_layer_color(4);
        break;
     default:
        if (rgb_matrix_get_flags() == LED_FLAG_NONE) {
          rgb_matrix_set_color_all(0, 0, 0);
        }
    }
  } else {
    if (rgb_matrix_get_flags() == LED_FLAG_NONE) {
      rgb_matrix_set_color_all(0, 0, 0);
    }
  }

  return true;
}




bool process_record_user(uint16_t keycode, keyrecord_t *record) {
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

