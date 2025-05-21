/* Split Keyboard
 */

#define MASTER_LEFT

/* Tap-Hold
 */

#define TAPPING_TERM 200
#define PERMISSIVE_HOLD
#define CHORDAL_HOLD

/* Caps Word
 */

#define BOTH_SHIFTS_TURNS_ON_CAPS_WORD

/* RGB Lighting
 */

// Reduce max brightness level to prevent the controller from crashing, as
// recommended in the keyboard's README.
#define RGBLIGHT_LIMIT_VAL 120

/* Vial
 */

#define VIAL_KEYBOARD_UID {0x3B, 0x6B, 0xA0, 0x29, 0x80, 0x56, 0xED, 0xD1}

// Secure unlock combination
// https://get.vial.today/docs/porting-to-vial.html#6-set-up-a-secure-unlock-combination
#define VIAL_UNLOCK_COMBO_ROWS {0, 0}
#define VIAL_UNLOCK_COMBO_COLS {0, 1}

#define DYNAMIC_KEYMAP_MACRO_COUNT 0
#define DYNAMIC_KEYMAP_MACRO_EEPROM_SIZE 0
