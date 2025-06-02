{
  cargo,
  fetchFromGitHub,
  lib,
  rustPlatform,
  rustc,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-termfilechooser-bridge";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "atomicptr";
    repo = "xdg-termfilechooser-bridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FnILhD7fWOjPNewputJlJlPRe2Ls9cQMzcPnfpLB3a8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+F1OZjuE5pJlcUEloKc5Iu29VyzhZxz/072zP8wGY7o=";
  };

  nativeBuildInputs = [
    rustc
    rustPlatform.cargoSetupHook
    cargo
  ];

  buildPhase = ''
    cargo build --release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/release/xdg-termfilechooser-bridge $out/bin/
  '';

  meta = {
    description = "The bridge between xdg-desktop-portal-termfilechooser and your favorite terminal based filepicker";
    homepage = "https://github.com/atomicptr/xdg-termfilechooser-bridge";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
