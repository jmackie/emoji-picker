{ pkgs ? import ./nix/nixpkgs { } }:
let
  rust-channel = import ./nix/rust-channel { inherit pkgs; };
  gtkBuildInputs = with pkgs; [
    # Cargo discovers libraries using pkgconfig
    pkgconfig
    # And here's what we need...
    gtk3
    glib
  ];
  buildRustPackage = pkgs.rustPlatform.buildRustPackage.override {
    cargo = rust-channel.cargo;
    # https://github.com/mozilla/nixpkgs-mozilla/issues/21
    rustc = rust-channel.rust;
  };
  Cargo_toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);

in buildRustPackage {
  pname = Cargo_toml.package.name;
  version = Cargo_toml.package.version;
  src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
  buildInputs = gtkBuildInputs;
  doCheck = false; # nothing to check atm
  cargoSha256 = # pkgs.lib.fakeSha256
    "04371bf0icwrd4sbyysd8mkxzhq12wy4cn8zyc4smckyvw6p32j3";

  # https://github.com/NixOS/nixpkgs/issues/79975
  legacyCargoFetcher = true;
}
