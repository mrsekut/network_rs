{ rustDate ? "2021-03-01" }:

let
  mozillaOverlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);

  nixpkgs = import <nixpkgs> { overlays = [ mozillaOverlay ]; };

  # toolchain = with nixpkgs; (rustChannelOf { date = rustDate; channel = "nightly"; });

  # rust_nightly = toolchain.rust.override {
  #   extensions = [ "rust-src" "rust-analysis" ];
  # };

in nixpkgs.mkShell {

  buildInputs = with nixpkgs; [
    # rust_nightly
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
  RUST_SRC_PATH = "${nixpkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
