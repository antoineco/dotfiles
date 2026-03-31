# The 'niri-session' startup script imports the entirety of the login manager's
# environment into systemd, so that it becomes available to the niri.service
# unit (and other user services).
# Not only calling 'systemctl import-environment' without argument is
# deprecated, but most of the login manager's environment is useless.
# In fact, some of the environment variables initialized by Bash inside
# niri-session can even become problematic when exported to the environment of
# the Wayland session (SHLVL, SHELL, TERM, PWD).
#
# Refs.
#   niri-wm/niri#254
#   niri-wm/niri#3734

{ niri }: niri.overrideAttrs { patches = [ ./systemd-no-import-env.patch ]; }
