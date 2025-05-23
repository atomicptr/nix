# This file was generated by GoReleaser. DO NOT EDIT.
# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{
system ? builtins.currentSystem
, lib
, fetchurl
, installShellFiles
, stdenvNoCC
}:
let
  shaMap = {
    x86_64-linux = "0rcwcn95xgzlmidayx4y4vzfljginjk0sa78cbdyd7sv8bg8zsil";
    x86_64-darwin = "0a3fbaq4prckcikdljq9q59y7pyd5cwf22xvb6r2b31pychlzgsx";
  };

  urlMap = {
    x86_64-linux = "https://github.com/atomicptr/crab/releases/download/v1.4.3/crab_1.4.3_linux_amd64.tar.gz";
    x86_64-darwin = "https://github.com/atomicptr/crab/releases/download/v1.4.3/crab_1.4.3_darwin_amd64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "crab";
  version = "1.4.3";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./crab $out/bin/crab
  '';

  system = system;

  meta = {
    description = "A versatile tool to crawl dozens of URLs from a given source, like a sitemap or an URL list.
";
    homepage = "https://github.com/atomicptr/crab";
    license = lib.licenses.mit;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
