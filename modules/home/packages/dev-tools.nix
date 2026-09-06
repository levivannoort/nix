# build, ci and linting tooling that came from the brewfile.
{ pkgs }:

with pkgs;
[
  pre-commit
  yamllint
  act
  earthly
  buildkit
]
