{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  libsecret,
  makeWrapper,
  nodejs,
  pkg-config,
}:

buildNpmPackage rec {
  pname = "vscode-php-debug";
  version = "1.40.1";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "vscode-php-debug";
    rev = "v${version}";
    hash = "sha256-ek9TJupjAwqmcaVIs18i9CSKXRZpMnpbOiS0wSnK+DQ=";
  };

  npmDepsHash = "sha256-MrS+fV5yOlEbRBmNirHKtKRyMfHPur5pzQavmBHeTqQ=";
  npmBuildScript = "build";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libsecret
  ];

  dontNpmPrune = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/vscode-php-debug $out/bin

    cp -r out node_modules package.json $out/libexec/vscode-php-debug

    makeWrapper ${lib.getExe nodejs} $out/bin/vscode-php-debug \
      --add-flags "$out/libexec/vscode-php-debug/out/phpDebug.js"

    runHook postInstall
  '';

  meta = {
    description = "PHP XDebug Debug Adapter Protocol Implementation";
    homepage = "https://github.com/xdebug/vscode-php-debug";
    license = lib.licenses.mit;
    mainProgram = "vscode-php-debug";
  };
}
