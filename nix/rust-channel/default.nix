{ pkgs, channel ? "nightly", channel-date ? "2019-11-30", extensions ? [ ] }:
let
  source = builtins.fromJSON (builtins.readFile ./source.json);
  nixpkgs-mozilla = pkgs.fetchgit { inherit (source) url rev sha256; };
  rust-overlay = import "${nixpkgs-mozilla.out}/rust-overlay.nix" pkgs pkgs;

  rustChannel = rust-overlay.rustChannelOf {
    inherit channel;
    date = channel-date;
  };
in rustChannel // {
  rust = rustChannel.rust.override {
    # Find what components have built here:
    # https://rust-lang.github.io/rustup-components-history/index.html
    inherit extensions;
  };
}
