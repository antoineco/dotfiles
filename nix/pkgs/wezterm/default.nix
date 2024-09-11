{
  wezterm,
  rustPlatform,
  fetchFromGitHub,
}:
wezterm.override (old: {
  rustPlatform = old.rustPlatform // {
    buildRustPackage =
      args:
      rustPlatform.buildRustPackage (
        args
        // (
          let
            rev = "30345b36d8a00fed347e4df5dadd83915a7693fb";
          in
          rec {
            pname = "wezterm";
            version = builtins.substring 0 9 rev;

            src = fetchFromGitHub {
              owner = "wez";
              repo = pname;
              rev = rev;
              fetchSubmodules = true;
              hash = "sha256-By7g1yImmuVba/MTcB6ajNSHeWDRn4gO+p0UOWcCEgE=";
            };

            postPatch = ''
              echo ${version} > .tag

              # tests are failing with: Unable to exchange encryption keys
              rm -r wezterm-ssh/tests
            '';

            # ERROR: The Cargo.lock contains git dependencies
            # This is currently not supported in the fixed-output derivation fetcher.
            # Use cargoLock.lockFile / importCargoLock instead.
            #cargoHash = lib.fakeHash

            cargoLock = {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "sqlite-cache-0.1.3" = "sha256-sBAC8MsQZgH+dcWpoxzq9iw5078vwzCijgyQnMOWIkk=";
                "xcb-imdkit-0.3.0" = "sha256-77KaJO+QJWy3tJ9AF1TXKaQHpoVOfGIRqteyqpQaSWo=";
              };
            };
          }
        )
      );
  };
})
