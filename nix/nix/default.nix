# Nix master plus the fixes the set needs, branch `main` of github.com/Mic92/nix-1, built by
# nixpkgs' component packaging.
#   https://github.com/NixOS/nix/pull/16459 required: dynamic derivations rebuild after gc
#   https://github.com/NixOS/nix/pull/16465 recommended: CA rebuilds of derivations that see
#     their $out (bootstrap/) do not conflict
#   https://github.com/NixOS/nix/pull/16477 recommended: a CA rebuild that differs from a
#     garbage-collected earlier output replaces its build trace instead of failing
{
  pkgs ? import (import ../nixpkgs.nix) { },
}:
let
  nix = pkgs.nixVersions.git.overrideAttrs (old: {
    pname = old.pname + "-Mic92";
    version = "2.36-unstable-2026-10-15";
    src = pkgs.fetchFromGitHub {
      owner = "Mic92";
      repo = "nix-1";
      rev = "a362dc976e165a404878cda05e0e50729aa28ba7";
      hash = "sha256-dIOeeAE6bvhLfUP8tDhNeq5TcvO3RZeWSOWwfmtV5RQ=";
    };
  });
in
nix
