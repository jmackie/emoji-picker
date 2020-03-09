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

  naersk = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "nmattia";
    repo = "naersk";
    # 2020-02-28T20:38:00+01:00
    rev = "ee15d1214a8fb58967a24d629062e4ccdd9a925a";
    sha256 = "1x5yjbizwvsqrwvfjaljd6wsfmd3ijvw2zgk89545nipqi5ibx7b";
  }) {
    cargo = rust-channel.cargo;
    rustc = rust-channel.rust;
    #                   ^^^^
    # https://github.com/mozilla/nixpkgs-mozilla/issues/21
  };

  Cargo_toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
in naersk.buildPackage {
  name = Cargo_toml.package.name;
  version = Cargo_toml.package.version;
  src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
  buildInputs = gtkBuildInputs;
}
