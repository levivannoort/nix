# nix

Declarative configuration for my workstations, so a reinstall is a `make switch`
rather than an afternoon. Built on [nix-darwin][nix-darwin] for macOS,
[NixOS][nixos] for Linux, and [home-manager][hm] for the user environment on
both.

## Hosts

| Host       | Platform        | Role                          |
| ---------- | --------------- | ----------------------------- |
| `lpws`     | `aarch64-darwin`| Personal laptop               |
| `apws`     | `aarch64-darwin`| Work laptop                   |
| `nixos-vm` | `aarch64-linux` | Throwaway VM for testing      |

## Layout

```
flake.nix              inputs, and the mkDarwin/mkNixos host builders
lib/                   importModules helper, enabled/disabled sugar, nixpkgs config
hosts/<host>/          per-host divergence only: platform, hostname, extras
modules/
  shared/              settings that apply to every system (nix daemon, gc, caches)
  darwin/              nix-darwin options: system defaults, homebrew, fonts, users
  nixos/               NixOS options: networking, virtualisation, locale, users
  home/                home-manager: the user environment on every platform
    packages/          package lists, split by concern
    programs/          one directory per program, auto-imported
```

The split by platform is load-bearing. `virtualisation.*` only exists on NixOS,
`system.defaults.*` only on darwin, and `programs.git.extraConfig` only in
home-manager — mixing them in one tree means a module cannot be imported
anywhere without breaking evaluation.

`modules/{darwin,nixos}/default.nix` and `modules/home/default.nix` discover
their children through `lib.importModules`, so adding a program is just adding
`modules/home/programs/<name>/default.nix`. There is no import list to update.

## Usage

```sh
make help      # list targets
make build     # build this host without activating
make switch    # build and activate
make check     # evaluate every host in the flake
make fmt       # format all Nix files
make lint      # deadnix + statix
make update    # bump flake inputs
make gc        # collect garbage older than 30 days
```

`make` picks the host from `hostname -s`, so run it on the machine you are
configuring or pass `HOSTNAME=` explicitly.

## Bootstrapping a new machine

1. Install Nix — the [Determinate Systems installer][dsi] enables flakes out of
   the box:

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Set the machine's hostname to match a host in `flake.nix`:

   ```sh
   sudo scutil --set ComputerName lpws
   sudo scutil --set LocalHostName lpws
   sudo scutil --set HostName lpws
   ```

3. On macOS, install the Xcode command line tools and Homebrew — nix-darwin
   drives Homebrew but does not install it:

   ```sh
   xcode-select --install
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

4. Apply:

   ```sh
   git clone https://github.com/levivannoort/nix ~/personal/nix
   cd ~/personal/nix
   make switch
   ```

   The first switch on macOS runs `nix run nix-darwin -- switch` because
   `darwin-rebuild` does not exist yet; afterwards it is on `PATH`.

## Notes

- `homebrew.onActivation.cleanup` is `"none"`, so Homebrew is additive: casks
  installed by hand are left alone. To make it fully declarative, reconcile
  `modules/darwin/homebrew.nix` against `brew list` and then set it to
  `"uninstall"` — the next switch removes everything not declared there.
- Unfree packages (terraform, packer, vscode) resolve because
  `modules/shared/nix.nix` sets `nixpkgs.config.allowUnfree`.
- `home-manager` is pinned to `release-25.05` to match nixpkgs. Bump both
  together or not at all.

[nix-darwin]: https://github.com/nix-darwin/nix-darwin
[nixos]: https://nixos.org
[hm]: https://github.com/nix-community/home-manager
[dsi]: https://github.com/DeterminateSystems/nix-installer
