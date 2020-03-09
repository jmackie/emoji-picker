{ pkgs ? import ./nix/nixpkgs { } }:
let
  rust-channel = import ./nix/rust-channel { inherit pkgs; };
  naersk = pkgs.callPackage ./nix/naersk { inherit rust-channel; };
  gtkBuildInputs = with pkgs; [
    # Cargo discovers libraries using pkgconfig
    pkgconfig
    # And here's what we need...
    gtk3
    glib
  ];
  Cargo_toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in naersk.buildPackage {
  name = Cargo_toml.package.name;
  version = Cargo_toml.package.version;
  src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
  buildInputs = gtkBuildInputs;
}
