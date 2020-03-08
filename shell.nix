{ pkgs ? import ./nix/nixpkgs { } }:
let
  rust-channel = import ./nix/rust-channel {
    inherit pkgs;
    extensions = [ "rls-preview" "rustfmt-preview" ];
  };
  gtkBuildInputs = with pkgs; [
    # Cargo discovers libraries using pkgconfig
    pkgconfig
    # And here's what we need...
    gtk3
    glib
  ];

in pkgs.mkShell {
  buildInputs = [ rust-channel.rust pkgs.cargo-watch ] ++ gtkBuildInputs;
}
