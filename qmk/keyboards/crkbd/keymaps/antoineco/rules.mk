NKRO_ENABLE = no # disable N-key rollover
OLED_ENABLE = no # disable support for OLED displays

CAPS_WORD_ENABLE = yes

RGBLIGHT_ENABLE   = yes
RGB_MATRIX_ENABLE = no

VIA_ENABLE  = yes
VIAL_ENABLE = yes

# AVR microcontrollers are resource constrained. We need to disable extra
# features in order to enable Vial support.
# References:
#  https://docs.qmk.fm/squeezing_avr
#  https://docs.qmk.fm/config_options#feature-options
#  https://get.vial.today/docs/firmware-size.html#qmk-settings

TAP_DANCE_ENABLE    = no # disable Tap Dance
KEY_OVERRIDE_ENABLE = no # disable Key Overrides
SPACE_CADET_ENABLE  = no # disable Space Cadet Shift
MAGIC_ENABLE        = no # disable Magic Keycodes
GRAVE_ESC_ENABLE    = no # disable Grave Escape
QMK_SETTINGS        = no # disable GUI configuration of QMK settings
