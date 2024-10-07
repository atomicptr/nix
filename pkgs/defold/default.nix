{
  fetchurl,
  lib,
  makeDesktopItem,
  makeWrapper,
  pkgs,
  stdenv,
  ...
}:

stdenv.mkDerivation rec {
  pname = "defold";
  version = "1.9.3";

  src = fetchurl {
    url = "https://github.com/defold/defold/releases/download/${version}/Defold-x86_64-linux.tar.gz";
    sha256 = "sha256-kLbdafbIAtby89XQGsGZKGp9xeRLzuaeLcju7ro+kK0=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/defold

    cp -r * $out/share/defold

    # install icon
    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm644 $out/share/defold/logo_blue.png $out/share/icons/hicolor/scalable/apps/Defold.png

    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/Defold \
      --append-flags $out/share/defold/Defold
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Defold";
      exec = "Defold %u";
      icon = "Defold";
      desktopName = "Defold";
      comment = "The game engine for high-performance cross-platform games";
      categories = [ "Development" ];
      startupWMClass = "Defold";
    })
  ];

  meta = {
    description = "The game engine for high-performance cross-platform games";
    homepage = "https://defold.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ atomicptr ];
    platforms = [ "x86_64-linux" ];
  };
}
