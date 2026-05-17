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
    '';
}
