# nix

A place to host my own nix packages

## Usage

Just fetch and import the tarball:

```nix
let
  atomicptr = import (fetchTarball "https://github.com/atomicptr/nix/master.tar.gz") {};
in
{
  environment.systemPackages = with pkgs; [
    atomicptr.playdate-sdk
  ];
}
```