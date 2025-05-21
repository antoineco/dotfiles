#include QMK_KEYBOARD_H

/* LAYOUT_split_3x6_3
┌───┬───┬───┬───┬───┬───┐         ┌───┬───┬───┬───┬───┬───┐
│   │   │   │   │   │   │         │   │   │   │   │   │   │
├───┼───┼───┼───┼───┼───┤         ├───┼───┼───┼───┼───┼───┤
│   │   │   │   │   │   │         │   │   │   │   │   │   │
├───┼───┼───┼───┼───┼───┤         ├───┼───┼───┼───┼───┼───┤
│   │   │   │   │   │   │         │   │   │   │   │   │   │
└───┴───┴───┴───┴───┴───┘         └───┴───┴───┴───┴───┴───┘
                ┌───┬───┬───┐ ┌───┬───┬───┐
                │   │   │   │ │   │   │   │
                └───┴───┴───┘ └───┴───┴───┘
 */

#define HM_A LCTL_T(KC_A)
#define HM_S LALT_T(KC_S)
#define HM_D LGUI_T(KC_D)
#define HM_F LSFT_T(KC_F)

#define HM_J RSFT_T(KC_J)
#define HM_K RGUI_T(KC_K)
#define HM_L LALT_T(KC_L)
#define HM_SCLN RCTL_T(KC_SCLN)

enum layers {
    _BL,
    _NL,
    _SL,
    _CL
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  /* Keymap _BL: Base Layer (Default Layer)
   */
[_BL] = LAYOUT_split_3x6_3(
    KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                        KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    XXXXXXX,
    KC_ESC,  HM_A,    HM_S,    HM_D,    HM_F,    KC_G,                        KC_H,    HM_J,    HM_K,    HM_L,    HM_SCLN, KC_QUOT,
    XXXXXXX, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                        KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, XXXXXXX,
                                        XXXXXXX, KC_BSPC, TL_UPPR,   TL_LOWR, KC_SPC,  KC_ENT
),
  /* Keymap _NL: Numbers and Navigation Layer
   */
[_NL] = LAYOUT_split_3x6_3(
    _______, KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                        KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    _______,
    _______, KC_LCTL, KC_LALT, KC_LGUI, KC_LSFT, XXXXXXX,                     KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, XXXXXXX, XXXXXXX,
    _______, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                     KC_HOME, KC_PGDN, KC_PGUP, KC_END,  XXXXXXX, _______,
                                        _______, KC_DEL,  _______,   _______, _______, _______
),
  /* Keymap _SL: Symbols Layer
   */
[_SL] = LAYOUT_split_3x6_3(
    _______, KC_EXLM, KC_AT,   KC_HASH, KC_DLR,  KC_PERC,                     KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, _______,
    _______, KC_LCTL, KC_LALT, KC_LGUI, KC_LSFT, XXXXXXX,                     KC_MINS, KC_EQL,  KC_LBRC, KC_RBRC, KC_BSLS, KC_GRV,
    KC_MUTE, KC_VOLD, KC_VOLU, KC_MPRV, KC_MPLY, KC_MNXT,                     KC_UNDS, KC_PLUS, KC_LCBR, KC_RCBR, KC_PIPE, KC_TILD,
                                        _______, _______, _______,   _______, _______, _______
),
  /* Keymap _CL: Keyboard Control Layer
   */
[_CL] = LAYOUT_split_3x6_3(
    QK_BOOT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    RM_TOGG, RM_HUEU, RM_SATU, RM_VALU, MS_BTN1, XXXXXXX,                     MS_LEFT, MS_DOWN, MS_UP,   MS_RGHT, XXXXXXX, XXXXXXX,
    RM_NEXT, RM_HUED, RM_SATD, RM_VALD, MS_BTN2, XXXXXXX,                     MS_WHLL, MS_WHLD, MS_WHLU, MS_WHLR, XXXXXXX, XXXXXXX,
                                        _______, _______, _______,   _______, _______, _______
)
};
