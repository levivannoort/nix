# Aggregates every package set. Split by concern so a package list stays
# reviewable and platform-specific entries have an obvious home.
{ pkgs }:

(import ./core.nix { inherit pkgs; })
++ (import ./cloud.nix { inherit pkgs; })
++ (import ./kubernetes.nix { inherit pkgs; })
++ (import ./languages.nix { inherit pkgs; })
++ (import ./virtualisation.nix { inherit pkgs; })
++ (import ./network.nix { inherit pkgs; })
