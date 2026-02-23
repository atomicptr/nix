{
  cargo,
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  rustPlatform,
  rustc,
  stdenv,
  xdg-desktop-portal,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-zenzai";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "atomicptr";
    repo = "xdg-desktop-portal-zenzai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IeSBDTz1tC+1y3VqzzRbBezt68eXWn5iQ5upJ5iHhTg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-CvEu+MJHegsCAXPegw5g9NmDwr2OUzDzIz+QBhQUk38=";
  };

  nativeBuildInputs = [
    meson
    rustc
    rustPlatform.cargoSetupHook
    cargo
    ninja
  ];

  buildInputs = [
    xdg-desktop-portal
  ];

  meta = {
    description = "A collection of several xdg-desktop-portal implementations to serve more lightweight wayland compositors like Hyprland";
    homepage = "https://github.com/atomicptr/xdg-desktop-portal-zenzai";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
