{ lib, ... }:

rec {
  # Sugar so modules read as `services.foo = mylib.enabled;`
  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  # Every child of `dir` that is itself a module: subdirectories (which carry a
  # default.nix) and .nix files other than default.nix. Adding a new program
  # module is then just creating the directory — no import list to keep in sync.
  importModules =
    dir:
    let
      entries = builtins.readDir dir;
      isModule =
        name: type:
        type == "directory" || (type == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name);
    in
    lib.mapAttrsToList (name: _: dir + "/${name}") (lib.filterAttrs isModule entries);

  # nixpkgs config shared by every host, so unfree tooling (terraform, packer,
  # vagrant, vscode) resolves identically everywhere.
  nixpkgsConfig = {
    allowUnfree = true;
  };
}
