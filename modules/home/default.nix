{
  pkgs,
  mylib,
  user,
  ...
}:

{
  imports = mylib.importModules ./programs;

  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";

    # This belongs under `home.`, not at the top level of the module — the old
    # hm/default.nix set a bare `stateVersion` attribute, which is not an option
    # and aborts evaluation.
    stateVersion = "25.05";

    packages = import ./packages { inherit pkgs; };

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less -FR";
    };
  };

  xdg.enable = true;
}
