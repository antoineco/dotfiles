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

enum layers {
    _BASE,
    _LOWR,
    _UPPR,
    _ADJU,
};

#define HM_A LCTL_T(KC_A)
#define HM_S LALT_T(KC_S)
#define HM_D LGUI_T(KC_D)
#define HM_F LSFT_T(KC_F)

#define HM_J RSFT_T(KC_J)
#define HM_K RGUI_T(KC_K)
#define HM_L LALT_T(KC_L)
#define HM_SCLN RCTL_T(KC_SCLN)

#define LL_SPC  LT(_LOWR, KC_SPC)
#define UL_BSPC LT(_UPPR, KC_BSPC)
#define AL_SPC  LT(_ADJU, KC_SPC)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  /* Base layer
   */
[_BASE] = LAYOUT(
    KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                        KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_BSPC,
    KC_ESC,  HM_A,    HM_S,    HM_D,    HM_F,    KC_G,                        KC_H,    HM_J,    HM_K,    HM_L,    HM_SCLN, KC_ENT,
    KC_LBRC, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                        KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH, KC_RBRC,
                                        XXXXXXX, XXXXXXX, UL_BSPC,   LL_SPC,  XXXXXXX, XXXXXXX
),
  /* Lower layer: Numbers, Navigation
   */
[_LOWR] = LAYOUT(
    KC_PERC, KC_PSLS, KC_P7,   KC_P8,   KC_P9,   KC_PAST,                     XXXXXXX, KC_LBRC, KC_LPRN, KC_RPRN, KC_RBRC, _______,
    KC_PEQL, KC_PMNS, KC_P4,   KC_P5,   KC_P6,   KC_PPLS,                     KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, XXXXXXX,
    KC_EXLM, KC_P0,   KC_P1,   KC_P2,   KC_P3,   KC_PDOT,                     KC_HOME, KC_PGDN, KC_PGUP, KC_END,  XXXXXXX, XXXXXXX,
                                        _______, _______, AL_SPC,    XXXXXXX, _______, _______
),
  /* Upper layer: Symbols
   */
[_UPPR] = LAYOUT(
    XXXXXXX, KC_GRV,  KC_AT,   KC_UNDS, KC_DOT,  XXXXXXX,                     KC_PERC, KC_LBRC, KC_LPRN, KC_RPRN, KC_RBRC, _______,
    KC_TILD, KC_LT,   KC_PIPE, KC_MINS, KC_GT,   KC_SLSH,                     KC_EXLM, KC_COMM, KC_LCBR, KC_RCBR, KC_SCLN, KC_QUES,
    XXXXXXX, KC_AMPR, KC_QUOT, KC_DQUO, KC_PLUS, KC_BSLS,                     KC_HASH, KC_CIRC, KC_COLN, KC_EQL,  KC_DLR,  KC_ASTR,
                                        _______, _______, XXXXXXX,   AL_SPC,  _______, _______
),
  /* Adjust layer: Media, Mouse, Keyboard control
   */
[_ADJU] = LAYOUT(
    QK_BOOT, XXXXXXX, RM_TOGG, RM_HUEU, RM_SATU, RM_VALU,                     XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    XXXXXXX, XXXXXXX, XXXXXXX, MS_BTN2, MS_BTN1, XXXXXXX,                     MS_LEFT, MS_DOWN, MS_UP,   MS_RGHT, XXXXXXX, XXXXXXX,
    KC_MUTE, KC_VOLD, KC_VOLU, KC_MPRV, KC_MPLY, KC_MNXT,                     MS_WHLL, MS_WHLD, MS_WHLU, MS_WHLR, XXXXXXX, XXXXXXX,
                                        XXXXXXX, XXXXXXX, XXXXXXX,   XXXXXXX, XXXXXXX, XXXXXXX
)
};

const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM =
LAYOUT(
    'L', 'L', 'L', 'L', 'L', 'L',            'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L',            'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L', 'L', 'L', 'L',            'R', 'R', 'R', 'R', 'R', 'R',
                        'L', 'L', '*',  '*', 'R', 'R'
);
