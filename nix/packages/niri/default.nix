# Wraps the niri package together with convenience shell scripts that can be
# invoked via key binds (volume control, etc.).
{
  lib,
  symlinkJoin,
  makeWrapper,
  writeShellApplication,
  niri,
  wireplumber,
  gawk,
  libnotify,
}:
symlinkJoin {
  pname = "${niri.pname}-wrapped";

  inherit (niri)
    version
    # passthru.providedSessions must be preserved that the wrapped package
    # remains compatible with services.displayManager.sessionPackages.
    passthru
    ;

  paths = [ niri ];

  buildInputs = [ makeWrapper ];
  postBuild =
    let
      setVolume = writeShellApplication {
        name = "wpctl-set-volume-osd";
        runtimeInputs = [
          wireplumber
          gawk
          libnotify
        ];
        text = ''
          wpctl set-volume @DEFAULT_AUDIO_SINK@ "$@"

          declare -i volume_percent=0
          volume_percent="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ \
          		| awk '{printf "%.0f", $2 * 100}')"

          notify-send \
          	--transient \
          	--expire-time=1000 \
          	--urgency=low \
          	--app-name=Niri \
          	--hint=string:synchronous:volume \
          	--hint=int:value:"$volume_percent" \
          	'''
        '';
      };
    in
    ''
      wrapProgram $out/bin/niri \
        --prefix PATH : ${lib.makeBinPath [ setVolume ]}

      rm $out/share/systemd/user/niri.service
      cp -p {${niri},$out}/share/systemd/user/niri.service
      substituteInPlace $out/share/systemd/user/niri.service \
        --replace-fail {${niri},$out}/bin/niri
    ''
    # The 'niri-session' startup script imports the entirety of the login
    # manager's environment into systemd, so that it becomes available to
    # the niri.service unit (and other user services).
    # Not only calling 'systemctl import-environment' without argument is
    # deprecated, but most of the login manager's environment is useless.
    # In fact, some of the environment variables initialized by Bash inside
    # niri-session can even become problematic when exported to the
    # environment of the Wayland session (SHLVL, SHELL, TERM, PWD).
    #
    # Refs.
    #   niri-wm/niri#254
    #   niri-wm/niri#3734
    + ''
      rm $out/bin/niri-session
      cp -p {${niri},$out}/bin/niri-session
      patch $out/bin/niri-session <${./systemd-no-import-env.patch}
    '';
}
