{
  description = "atomicptr/nix - My nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      importPackages =
        pkgs:
        let
          packageDirs = builtins.attrNames (builtins.readDir ./pkgs);
          packages = builtins.listToAttrs (
            map (name: {
              inherit name;
              value = pkgs.callPackage (./pkgs + "/${name}") { };
            }) packageDirs
          );
        in
        packages;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        importPackages pkgs
      );
    };
}
