{ lib, fetchurl, stdenvNoCC }:
let
  # this has to be updated manually
  date = "2024-09-26";
  # use this to regenerate:
  #    curl -sSf -o /tmp/dune "https://download.dune.ci.dev/$(date +%Y-%m-%d)/x86_64-unknown-linux-musl/dune" && sha256sum /tmp/dune && rm /tmp/dune
  hash = "c0b235edf38392eb1d9ac13ee0ba8e993b3602eb6218dcb7f38bfa66a52fd63f";
  arch = "x86_64-unknown-linux-musl";
in
stdenvNoCC.mkDerivation {
  pname = "dune-developer-preview";
  version = builtins.replaceStrings ["-"] ["."] date;
  src = fetchurl {
    url = "https://download.dune.ci.dev/${date}/${arch}/dune";
    sha256 = hash;
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -vr $src $out/bin/dune
    chmod +x $out/bin/dune
  '';

  meta = {
    description = "Dune Developer Preview";
    homepage = "https://dune.ci.dev/";
    license = lib.licenses.mit;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "x86_64-linux"
    ];
  };
}
