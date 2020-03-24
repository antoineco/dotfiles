#include QMK_KEYBOARD_H

# define _BL 0
# define _FL 1
# define _CL 2

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  /* Keymap _BL: Base Layer (Default Layer)
   */
[_BL] = LAYOUT(
    KC_GESC,  KC_1,  KC_2,  KC_3,  KC_4,  KC_5,  KC_6,  KC_7,  KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,
    KC_TAB,   KC_Q,  KC_W,  KC_E,  KC_R,  KC_T,  KC_Y,  KC_U,  KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,
    KC_CAPS,  KC_A,  KC_S,  KC_D,  KC_F,  KC_G,  KC_H,  KC_J,  KC_K,     KC_L,     KC_SCLN,  KC_QUOT,  KC_ENT,
    KC_LSFT,  KC_Z,  KC_X,  KC_C,  KC_V,  KC_B,  KC_N,  KC_M,  KC_COMM,  KC_DOT,   RSFT_T(KC_SLSH),    KC_UP,    KC_DEL,
    KC_LCTL,  KC_LGUI,  KC_LALT,                 KC_SPC,                 KC_RALT,  MO(_FL),  KC_LEFT,  KC_DOWN,  KC_RGHT
),
  /* Keymap _FL: Function Layer
   */
[_FL] = LAYOUT(
    _______,  KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  KC_VOLD,  KC_VOLU,  KC_MUTE,  KC_MPLY,  KC_MPRV,  KC_MNXT,  _______,  _______,  _______,  KC_INS,             KC_PGUP,  _______,
    _______,  _______,  _______,                                TO(_CL),                      _______,  _______,  KC_HOME,  KC_PGDN,  KC_END
),
  /* Keymap _CL: Keyboard Control Layer
   */
[_CL] = LAYOUT(
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  EEP_RST,
    _______,  RGB_TOG,  RGB_MOD,  RGB_VAI,  RGB_HUI,  RGB_SAI,  RGB_SPI,  _______,  _______,  _______,  _______,  _______,  _______,  RESET,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,
    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,            _______,  _______,
    _______,  _______,  _______,                                _______,                      _______,  TO(_BL),  _______,  _______,  _______
)
};

void rgb_matrix_indicators_user(void) {
    if (g_suspend_state || !rgb_matrix_config.enable) return;

    if (host_keyboard_led_state().caps_lock) {
        rgb_matrix_set_color(40, RGB_WHITE); // KC_CAPSLOCK
    }

    uint8_t active_layer = biton32(layer_state);

    switch (active_layer) {
    case _FL:
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
        rgb_matrix_set_color(26, RGB_PURPLE);    // RGB_TOG
        rgb_matrix_set_color(25, RGB_TURQUOISE); // RGB_MODE_FORWARD
        rgb_matrix_set_color(24, RGB_TURQUOISE); // RGB_VAI
        rgb_matrix_set_color(23, RGB_TURQUOISE); // RGB_HUI
        rgb_matrix_set_color(22, RGB_TURQUOISE); // RGB_SAI
        rgb_matrix_set_color(21, RGB_TURQUOISE); // RGB_SPI
        /* QMK keys
         */
        rgb_matrix_set_color(0,  RGB_ORANGE); // EEPROM_RESET
        rgb_matrix_set_color(14, RGB_RED);    // RESET
        break;
    }
}
