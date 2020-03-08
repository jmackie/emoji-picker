# nix-prefetch-git https://github.com/NixOS/nixpkgs | tee source.json
let source = builtins.fromJSON (builtins.readFile ./source.json);
in import (builtins.fetchTarball {
  name = "nixpkgs-${source.rev}";
  url = "https://github.com/nixos/nixpkgs/archive/${source.rev}.tar.gz";
  inherit (source) sha256;
})
