let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  pkgs = import <nixpkgs> {
    overlays = [ moz_overlay ];
  };
  # pkgs = import (fetchTarball("https://github.com/NixOS/nixpkgs/archive/04ac9dcd311956d1756d77f4baf9258392ee7bdd.tar.gz")) {};

in pkgs.mkShell {

  buildInputs = with pkgs; [
    cargo
    rustc
    rustfmt
    rustup
    rls
  ];

  shellHook = ''
    rustup install nightly
    rustup component add rls rust-analysis rust-src
  '';

  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela.
  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}