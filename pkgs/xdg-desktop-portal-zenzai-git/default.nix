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
  pname = "xdg-desktop-portal-zenzai-git";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "atomicptr";
    repo = "xdg-desktop-portal-zenzai";
    rev = "master";
    hash = "sha256-8SPHk5n9zn2Qxus/zFYxclXKcZvr6+LQTx5kAmIdvSU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TiEnlceSx/tXZ97axeRhEv6YhaA9X/qP/vloP5vx4gM=";
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
