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
  version = "1.40.2";

  src = fetchFromGitHub {
    owner = "xdebug";
    repo = "vscode-php-debug";
    rev = "v${version}";
    hash = "sha256-AKAPeQfK+GUF8xq74tbnJHrpPrLkLk2yfPb40sRQNwQ=";
  };

  npmDepsHash = "sha256-8ra+w9/xMpPdcp6OpvhofzzROr+N8w4nNQO7w5h/o5o=";
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
