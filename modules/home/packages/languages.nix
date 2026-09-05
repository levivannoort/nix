{ pkgs }:

with pkgs;
[
  go
  gopls
  lua
  lua-language-server
  # `goose` in nixpkgs is the SQL migration tool. If you meant Block's AI agent,
  # that attribute is `block-goose-cli`.
  goose
]
