{ lib, fetchurl, stdenvNoCC }:
let
  # this has to be updated manually
  date = "2024-09-27";
  # use this to regenerate:
  #    curl -sSf -o /tmp/dune "https://download.dune.ci.dev/$(date +%Y-%m-%d)/x86_64-unknown-linux-musl/dune" && sha256sum /tmp/dune && rm /tmp/dune
  hash = "2199ed5a14afed3d63816ef51666b12fc6edc4a783f9dcbe709bb4a08fb59f54";
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
