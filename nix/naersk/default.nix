{ callPackage, fetchFromGitHub, rust-channel }:
let source = builtins.fromJSON (builtins.readFile ./source.json);
in callPackage (fetchFromGitHub {
  owner = "nmattia";
  repo = "naersk";
  inherit (source) rev sha256;
}) {
  cargo = rust-channel.cargo;
  rustc = rust-channel.rust;
  #                    ^^^^
  # https://github.com/mozilla/nixpkgs-mozilla/issues/21
}
