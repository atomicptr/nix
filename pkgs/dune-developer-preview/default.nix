{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  # this has to be updated manually
  date = "2024-10-08";
  # use this to regenerate:
  #    curl -sSf -o /tmp/dune "https://get.dune.build/$(date +%Y-%m-%d)/x86_64-unknown-linux-musl/dune" && sha256sum /tmp/dune && rm /tmp/dune
  hash = "9e38b47a15cc9cfe8301131220b3190be60bb7cfaaa42ba7f80cd75b7041bb8a";
  arch = "x86_64-unknown-linux-musl";
in
stdenvNoCC.mkDerivation {
  pname = "dune-developer-preview";
  version = builtins.replaceStrings [ "-" ] [ "." ] date;
  src = fetchurl {
    url = "https://get.dune.build/${date}/${arch}/dune";
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
    homepage = "https://preview.dune.build";
    license = lib.licenses.mit;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "x86_64-linux"
    ];
  };
}
