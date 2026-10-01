{
  clang,
  clangStdenv,
  copyDesktopItems,
  egl-wayland,
  fetchFromGitHub,
  freetype,
  lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  makeDesktopItem,
  makeWrapper,
  mesa,
  pkg-config,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "raddebugger";
  version = "0.9.29-alpha";

  src = fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IQNicRWKdIamDeQU1RRceRR2QgoUlomQYoeCgepO10w=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    clang
    makeWrapper
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    egl-wayland
    freetype
    libGL
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    mesa
  ];

  postPatch = ''
    patchShebangs build.sh

    substituteInPlace build.sh \
      --replace-fail 'git_hash=$(git describe --always --dirty)' 'git_hash="v${finalAttrs.version}"' \
      --replace-fail 'git_hash_full=$(git rev-parse HEAD)' 'git_hash_full="v${finalAttrs.version}"'
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh raddbg release clang no_meta=0

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/raddbg $out/bin/

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp data/logo.png $out/share/icons/hicolor/256x256/apps/raddbg.png

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/raddbg \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          mesa
          egl-wayland
          libx11
          libxext
        ]
      }"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "raddbg";
      desktopName = "RAD Debugger";
      genericName = "Debugger";
      comment = "A native, user-mode, multi-process, graphical debugger";
      exec = "raddbg %U";
      icon = "raddbg";
      categories = [
        "Development"
        "Debugger"
      ];
      terminal = false;
      startupNotify = true;
    })
  ];

  meta = with lib; {
    description = "A native, user-mode, multi-process, graphical debugger.";
    homepage = "https://github.com/EpicGames/raddebugger";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "raddbg";
    maintainers = with lib.maintainers; [ atomicptr ];
  };
})
