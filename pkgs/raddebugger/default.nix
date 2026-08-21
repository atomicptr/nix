{
  clang,
  clangStdenv,
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
  makeWrapper,
  mesa,
  pkg-config,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "raddebugger";
  version = "0.9.28-alpha";

  src = fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lwSNKMXfdM9VJoUyxieIUEnvc0PxhdZTkB9WCOe0tfI=";
  };

  nativeBuildInputs = [
    clang
    makeWrapper
    pkg-config
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

  meta = with lib; {
    description = "A native, user-mode, multi-process, graphical debugger.";
    homepage = "https://github.com/EpicGames/raddebugger";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "raddbg";
    maintainers = with lib.maintainers; [ atomicptr ];
  };
})
