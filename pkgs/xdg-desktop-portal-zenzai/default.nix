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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "atomicptr";
    repo = "xdg-desktop-portal-zenzai";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/aXCm2yvn/KuzW9qduZyKAs8WM8qSBNjnsXgyuxdq0k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-9vGDZ3U1GG/BqGyGJMigVyhaaoXQqJ1WQF419LxEqg8=";
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
