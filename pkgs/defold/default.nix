{
  fetchurl,
  lib,
  makeDesktopItem,
  makeWrapper,
  pkgs,
  stdenvNoCC,
  ...
}:

stdenvNoCC.mkDerivation rec {
  pname = "defold";
  version = "1.9.4";

  src = fetchurl {
    url = "https://github.com/defold/defold/releases/download/${version}/Defold-x86_64-linux.tar.gz";
    sha256 = "49b48475a7f88ec1d632bcc5a193acdfb2cf55169f95c7b73bb3bdcba050d1b7";
  };

  desktopItem = makeDesktopItem {
    name = "Defold";
    exec = "Defold %u";
    icon = "Defold";
    desktopName = "Defold";
    comment = "The game engine for high-performance cross-platform games";
    categories = [ "Development" ];
    startupWMClass = "com.defold.editor.Start";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/defold
    mkdir -p $out/share/applications

    # move desktop file into applications
    cp ${desktopItem}/share/applications/* $out/share/applications/

    cp -r * $out/share/defold

    # install icon
    install -Dm644 $out/share/defold/logo_blue.png $out/share/icons/hicolor/512x512/apps/Defold.png

    makeWrapper ${pkgs.steam-run}/bin/steam-run $out/bin/Defold \
      --append-flags $out/share/defold/Defold
  '';

  meta = {
    description = "The game engine for high-performance cross-platform games";
    homepage = "https://defold.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ atomicptr ];
    platforms = [ "x86_64-linux" ];
  };
}
