{ pkgs ? import <nixpkgs> {} }:

(import ./composition.nix { inherit pkgs; nodejs = pkgs.nodejs; system = pkgs.system; })
