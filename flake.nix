{
  description = ".dotfiles github.com/levivannoort";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Pinned to the matching release branch. Tracking home-manager master
    # against a stable nixpkgs is the single most common source of eval
    # breakage in a flake like this one.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      mylib = import ./lib { inherit lib; };

      user = "levi";

      # Every system this repo is expected to evaluate on. Used for devShells,
      # formatter and checks — NOT for the host configurations, which pin their
      # own platform via nixpkgs.hostPlatform.
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # Shared home-manager wiring. useGlobalPkgs makes home-manager consume the
      # system's pkgs (with our nixpkgs.config), so allowUnfree is honoured in
      # exactly one place.
      homeManagerConfig = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit inputs mylib user; };
          users.${user} = import ./modules/home;
        };
      };

      mkDarwin =
        hostname:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              inputs
              mylib
              user
              hostname
              ;
          };
          modules = [
            ./hosts/${hostname}
            ./modules/darwin
            home-manager.darwinModules.home-manager
            homeManagerConfig
          ];
        };

      mkNixos =
        hostname:
        lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              mylib
              user
              hostname
              ;
          };
          modules = [
            ./hosts/${hostname}
            ./modules/nixos
            home-manager.nixosModules.home-manager
            homeManagerConfig
          ];
        };
    in
    {
      inherit mylib;

      darwinConfigurations = {
        lpws = mkDarwin "lpws";
        apws = mkDarwin "apws";
      };

      nixosConfigurations = {
        nixos-vm = mkNixos "nixos-vm";
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-rfc-style
            nil
            deadnix
            statix
          ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      # `nix flake check` evaluates these, which is what actually catches the
      # option-name typos that used to sit in this repo unnoticed.
      checks = forAllSystems (
        pkgs:
        let
          system = pkgs.stdenv.hostPlatform.system;
          named = lib.mapAttrs' (n: v: lib.nameValuePair "darwin-${n}" v.system) (
            lib.filterAttrs (_: v: v.pkgs.stdenv.hostPlatform.system == system) self.darwinConfigurations
          );
          nixos = lib.mapAttrs' (n: v: lib.nameValuePair "nixos-${n}" v.config.system.build.toplevel) (
            lib.filterAttrs (_: v: v.pkgs.stdenv.hostPlatform.system == system) self.nixosConfigurations
          );
        in
        named // nixos
      );
    };
}
