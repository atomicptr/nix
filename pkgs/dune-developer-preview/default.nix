{
  lib,
  fetchzip,
  stdenvNoCC,
}:
let
  # this has to be updated manually
  date = "2024-12-05";
  # use this to regenerate:
  #    export DUNE_VERSION="2024-11-03" && curl -sSf -o /tmp/dune "https://get.dune.build/$DUNE_VERSION/x86_64-unknown-linux-musl/dune" && sha256sum /tmp/dune && rm /tmp/dune
  hash = "sha256-wIJ4AUIEoGWXorvPqpLpKQyDLaF5/igsLTInoM+lC7E=";
  arch = "x86_64-unknown-linux-musl";
in
stdenvNoCC.mkDerivation {
  pname = "dune-developer-preview";
  version = builtins.replaceStrings [ "-" ] [ "." ] date;
  src = fetchzip {
    url = "https://get.dune.build/${date}/${arch}/dune-${date}-${arch}.tar.gz";
    sha256 = hash;
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -vr $src/dune $out/bin/dune
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
