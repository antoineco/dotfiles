# Wraps the ghostty package in a way that forces GTK 4 to handle the Xorg
# Compose Key.
#   https://github.com/ghostty-org/ghostty/discussions/8899#discussioncomment-14717979
#   https://github.com/niri-wm/niri/blob/v26.04/docs/wiki/Application-Issues.md#gtk-4-dead-keys--compose
{
  symlinkJoin,
  makeWrapper,
  ghostty,
}:
symlinkJoin {
  pname = "${ghostty.pname}-wrapped";
  inherit (ghostty) version;

  passthru = ghostty.passthru // {
    unwrapped = ghostty;
  };

  paths = [ ghostty ];

  buildInputs = [ makeWrapper ];
  # bin/ghostty is itself a (binary) wrapper which execs ghostty from the Nix
  # store path of the *upstream* package, therefore we can remove the original
  # .ghostty-wrapped ELF executable.
  postBuild = ''
    rm $out/bin/.ghostty-wrapped
    wrapProgram $out/bin/ghostty \
      --set GTK_IM_MODULE simple

    rm $out/share/applications/com.mitchellh.ghostty.desktop
    cp -p {${ghostty},$out}/share/applications/com.mitchellh.ghostty.desktop
    substituteInPlace $out/share/applications/com.mitchellh.ghostty.desktop \
      --replace-fail {${ghostty},$out}/bin/ghostty

    rm $out/share/systemd/user/app-com.mitchellh.ghostty.service
    cp -p {${ghostty},$out}/share/systemd/user/app-com.mitchellh.ghostty.service
    substituteInPlace $out/share/systemd/user/app-com.mitchellh.ghostty.service \
      --replace-fail {${ghostty},$out}/bin/ghostty
  '';
}
