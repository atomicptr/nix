# nix

A place to host my own nix packages

## Usage

### Flake

Just add this repo as an input

```nix
{
  # ...
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    atomicptr.url = "github:atomicptr/nix";
    # ...
  };

  # ...
}
````

### Regular

Just fetch and import the repository:

```nix
let
  atomicptr = import (fetchGit { url = "http://github.com/atomicptr/nix.git"; }) {
    pkgs = import <nixpkgs> {
      config = {
        allowUnfree = true;
      };
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    atomicptr.PACKAGE_NAME
  ];
}
```
