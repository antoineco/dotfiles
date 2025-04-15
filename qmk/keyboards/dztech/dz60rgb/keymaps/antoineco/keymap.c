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
    _EL,
    _QL,
    _PL,
    _FL,
    _CL
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  /* Keymap _EL: Engram Layer, Mac (Default Layer)
   */
[_EL] = LAYOUT(
    KC_LBRC,  KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_RBRC,  KC_SLSH,  KC_BSPC,
    KC_TAB,   KC_B,     KC_Y,     KC_O,     KC_U,     KC_QUOT,  KC_DQT,   KC_L,     KC_D,     KC_W,     KC_V,     KC_Z,     KC_HASH,  KC_AT,
    KC_ESC,   KC_C,     KC_I,     KC_E,     KC_A,     KC_COMM,  KC_DOT,   KC_H,     KC_T,     KC_S,     KC_N,     KC_Q,     KC_ENT,
    KC_LSFT,  KC_G,     KC_X,     KC_J,     KC_K,     KC_MINS,  KC_QUES,  KC_R,     KC_M,     KC_F,     RSFT_T(KC_P),       KC_UP,    KC_DEL,
    KC_LCTL,  KC_LALT,  KC_LGUI,                                KC_SPC,                       KC_RGUI,  MO(_FL),  KC_LEFT,  KC_DOWN,  KC_RGHT
),
  /* Keymap _QL: QWERTY Layer, Mac
   */
[_QL] = LAYOUT(
    QK_GESC,  KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   _______,
    _______,  KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,
    KC_CAPS,  KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,  KC_ENT,
    _______,  KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   RSFT_T(KC_SLSH),    _______,  _______,
    _______,  _______,  _______,                                _______,                      _______,  _______,  _______,  _______,  _______
),
  /* Keymap _PL: PC Modifiers Layer
   */
[_PL] = LAYOUT(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,  _______,
    _______,  KC_LGUI,  KC_LALT,                                _______,                      KC_RALT,  _______,  _______,  _______,  _______
),
  /* Keymap _FL: Function Layer
   */
[_FL] = LAYOUT(
    KC_GRV,   KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   _______,
    _______,  TG(_QL),  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  TG(_PL),  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  KC_VOLD,  KC_VOLU,  KC_MUTE,  KC_MPLY,  KC_MPRV,  KC_MNXT,  _______,  _______,  _______,  KC_INS,             KC_PGUP,  _______,
    _______,  _______,  _______,                                TO(_CL),                      _______,  _______,  KC_HOME,  KC_PGDN,  KC_END
),
  /* Keymap _CL: Keyboard Control Layer
   */
[_CL] = LAYOUT(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  EE_CLR,
    _______,  RM_TOGG,  RM_NEXT,  RM_VALU,  RM_HUEU,  RM_SATU,  RM_SPDU,  _______,  _______,  _______,  _______,  _______,  _______,  QK_BOOT,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,  _______,
    _______,  _______,  _______,                                _______,                      _______,  TO(_EL),  _______,  _______,  _______
)
};

const custom_shift_key_t custom_shift_keys[] = {
    /* Engram layout shifted symbols */
    {KC_LBRC, KC_LCBR},
    {KC_1,    KC_PIPE},
    {KC_2,    KC_EQL},
    {KC_3,    KC_TILD},
    {KC_4,    KC_PLUS},
    {KC_5,    KC_LT},
    {KC_6,    KC_GT},
    {KC_7,    KC_CIRC},
    {KC_8,    KC_AMPR},
    {KC_9,    KC_PERC},
    {KC_0,    KC_ASTR},
    {KC_RBRC, KC_RCBR},
    {KC_SLSH, KC_BSLS},
    {KC_QUOT, KC_LPRN},
    {KC_DQT,  KC_RPRN},
    {KC_HASH, KC_DLR},
    {KC_AT,   KC_GRV},
    {KC_COMM, KC_SCLN},
    {KC_DOT,  KC_COLN},
    {KC_MINS, KC_UNDS},
    {KC_QUES, KC_EXLM},
};

bool rgb_matrix_indicators_user(void) {
    switch (biton32(layer_state)) {
    case _FL:
        /* Layer toggle keys
         */
        rgb_matrix_set_color(26, RGB_RED); // KC_Q
        rgb_matrix_set_color(17, RGB_RED); // KC_P
        /* Media keys
         */
        rgb_matrix_set_color(52, RGB_WHITE); // KC_AUDIO_VOL_DOWN
        rgb_matrix_set_color(51, RGB_WHITE); // KC_AUDIO_VOL_UP
        rgb_matrix_set_color(50, RGB_WHITE); // KC_AUDIO_MUTE
        rgb_matrix_set_color(49, RGB_WHITE); // KC_MEDIA_PLAY_PAUSE
        rgb_matrix_set_color(48, RGB_WHITE); // KC_MEDIA_PREV_TRACK
        rgb_matrix_set_color(47, RGB_WHITE); // KC_MEDIA_NEXT_TRACK
        /* Special keys
         */
        rgb_matrix_set_color(43, RGB_GOLD);   // KC_INSERT
        rgb_matrix_set_color(56, RGB_YELLOW); // KC_HOME
        rgb_matrix_set_color(54, RGB_YELLOW); // KC_END
        rgb_matrix_set_color(42, RGB_ORANGE); // KC_PGUP
        rgb_matrix_set_color(55, RGB_ORANGE); // KC_PGDOWN
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
