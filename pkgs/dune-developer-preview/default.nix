{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  # this has to be updated manually
  date = "2024-11-03";
  # use this to regenerate:
  #    export DUNE_VERSION="2024-11-03" && curl -sSf -o /tmp/dune "https://get.dune.build/$DUNE_VERSION/x86_64-unknown-linux-musl/dune" && sha256sum /tmp/dune && rm /tmp/dune
  hash = "74bfc562af483d158ba8dac61b217b3edeef02670b9dc6188d572c8badeea580";
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
