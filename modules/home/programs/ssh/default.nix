{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    # These are top-level options in home-manager, not per-matchBlock ones.
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "10m";
    serverAliveInterval = 60;
    hashKnownHosts = true;

    matchBlocks = {
      "*" = {
        identitiesOnly = true;
        # UseKeychain is an Apple extension; OpenSSH on Linux rejects it.
        extraOptions = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };
      };

      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
