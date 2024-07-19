{
  pkgs ? import <nixpkgs> { },
}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs);
  packageDirs = builtins.attrNames (builtins.readDir ./pkgs);
in
builtins.listToAttrs (
  map (name: {
    inherit name;
    value = callPackage (./pkgs + "/${name}") { };
  }) packageDirs
)
