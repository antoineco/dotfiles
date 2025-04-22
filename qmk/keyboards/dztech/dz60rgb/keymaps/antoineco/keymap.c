#include QMK_KEYBOARD_H

/* LAYOUT_60_ansi_arrow
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───────┐
│   │   │   │   │   │   │   │   │   │   │   │   │   │       │
├───┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─────┤
│     │   │   │   │   │   │   │   │   │   │   │   │   │     │
├─────┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴─────┤
│      │   │   │   │   │   │   │   │   │   │   │   │        │
├──────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴───┴┬───┬───┤
│        │   │   │   │   │   │   │   │   │   │      │   │   │
├────┬───┴┬──┴─┬─┴───┴───┴───┴───┴───┴──┬┴──┬┴──┬───┼───┼───┤
│    │    │    │                        │   │   │   │   │   │
└────┴────┴────┴────────────────────────┴───┴───┴───┴───┴───┘
 */

enum layers {
    _BL,
    _NL,
    _PL,
    _FL,
    _CL
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  /* Keymap _BL: Base Layer, Mac (Default Layer)
   */
[_BL] = LAYOUT(
    KC_GRV,   KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,
    KC_TAB,   KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,
    KC_ESC,   KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,            KC_ENT,
    KC_LSFT,            KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   RSFT_T(KC_SLSH),    _______,  _______,
    KC_LCTL,  KC_LALT,  KC_LGUI,                                LT(_NL,KC_SPC),                         KC_RGUI,  MO(_FL),  _______,  _______,  _______
),
  /* Keymap _NL: Navigation Layer
   */
[_NL] = LAYOUT(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  KC_DEL,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  KC_CAPS,  KC_LEFT,  KC_DOWN,  KC_UP,    KC_RGHT,  _______,  _______,            _______,
    _______,            _______,  _______,  _______,  _______,  KC_INS,   KC_HOME,  KC_PGDN,  KC_PGUP,  KC_END,   _______,            _______,  _______,
    _______,  _______,  _______,                                _______,                                _______,  _______,  _______,  _______,  _______
),
  /* Keymap _PL: PC Layer
   */
[_PL] = LAYOUT(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,
    _______,            _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,  _______,
    _______,  KC_LGUI,  KC_LALT,                                _______,                                KC_RALT,  _______,  _______,  _______,  _______
),
  /* Keymap _FL: Function Layer
   */
[_FL] = LAYOUT(
    _______,  KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  TG(_PL),  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,
    _______,            KC_VOLD,  KC_VOLU,  KC_MUTE,  KC_MPLY,  KC_MPRV,  KC_MNXT,  _______,  _______,  _______,  _______,            _______,  _______,
    _______,  _______,  _______,                                TO(_CL),                                _______,  _______,  _______,  _______,  _______
),
  /* Keymap _CL: Keyboard Control Layer
   */
[_CL] = LAYOUT(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  EE_CLR,
    _______,  RM_TOGG,  RM_NEXT,  RM_VALU,  RM_HUEU,  RM_SATU,  RM_SPDU,  _______,  _______,  _______,  _______,  _______,  _______,  QK_BOOT,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,
    _______,            _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,  _______,
    _______,  _______,  _______,                                _______,                                _______,  TO(_BL),  _______,  _______,  _______
)
};

bool rgb_matrix_indicators_user(void) {
    switch (biton32(layer_state)) {
    case _FL:
        /* Layer toggle keys
         */
        rgb_matrix_set_color(17, RGB_RED); // KC_P
        /* Media keys
         */
        rgb_matrix_set_color(52, RGB_WHITE); // KC_AUDIO_VOL_DOWN
        rgb_matrix_set_color(51, RGB_WHITE); // KC_AUDIO_VOL_UP
        rgb_matrix_set_color(50, RGB_WHITE); // KC_AUDIO_MUTE
        rgb_matrix_set_color(49, RGB_WHITE); // KC_MEDIA_PLAY_PAUSE
        rgb_matrix_set_color(48, RGB_WHITE); // KC_MEDIA_PREV_TRACK
        rgb_matrix_set_color(47, RGB_WHITE); // KC_MEDIA_NEXT_TRACK
        break;
    case _CL:
        /* RGB control keys
         */
        rgb_matrix_set_color(26, RGB_PURPLE);    // RM_TOGG / QK_RGB_MATRIX_TOGGLE
        rgb_matrix_set_color(25, RGB_TURQUOISE); // RM_NEXT / QK_RGB_MATRIX_MODE_NEXT
        rgb_matrix_set_color(24, RGB_TURQUOISE); // RM_VALU / QK_RGB_MATRIX_VALUE_UP
        rgb_matrix_set_color(23, RGB_TURQUOISE); // RM_HUEU / QK_RGB_MATRIX_HUE_UP
        rgb_matrix_set_color(22, RGB_TURQUOISE); // RM_SATU / QK_RGB_MATRIX_SATURATION_UP
        rgb_matrix_set_color(21, RGB_TURQUOISE); // RM_SPDU / QK_RGB_MATRIX_SPEED_UP
        /* QMK keys
         */
        rgb_matrix_set_color(0,  RGB_ORANGE); // QK_CLEAR_EEPROM
        rgb_matrix_set_color(14, RGB_RED);    // QK_BOOTLOADER
        break;
    }

    return true;
}
