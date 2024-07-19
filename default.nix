{
  pkgs ? import <nixpkgs> { },
  config ? {},
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // { inherit config; });
  packageDirs = builtins.attrNames (builtins.readDir ./pkgs);
in
builtins.listToAttrs (
  map (name: {
    inherit name;
    value = callPackage (./pkgs + "/${name}") { };
  }) packageDirs
)
