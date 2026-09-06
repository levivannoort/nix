## nix

declarative configuration for workstations: three machines, one flake.
`nix-darwin` manages the two macbooks, `nixos` manages the vm, and
`home-manager` owns the user environment on all of them, so the shell, editor
and terminal are identical everywhere.

| host       | platform         | role                     |
| :--------- | :--------------- | :----------------------- |
| `lpws`     | `aarch64-darwin` | personal laptop          |
| `apws`     | `aarch64-darwin` | work laptop              |
| `vmte`     | `aarch64-linux`  | virtual machine          |

## adding things

`modules/{darwin,nixos}/default.nix` and `modules/home/default.nix` discover
their children through `lib.importModules`, so a new program is just a new
directory:

```sh
mkdir -p modules/home/programs/ripgrep
$EDITOR modules/home/programs/ripgrep/default.nix
```

there is no import list to keep in sync. packages work the same way: drop them
in the matching file under `modules/home/packages/`, or add a new file and
reference it from that directory's `default.nix`.

## usage

```sh
make help        # list every target
make build       # build this host, do not activate
make switch      # build and activate
make check       # evaluate all three hosts
make fmt         # format every nix file
make fmt-check   # fail if anything is unformatted
make lint        # deadnix and statix
make update      # bump flake inputs, commit the lock
make gc          # collect garbage older than 30 days
make repl        # open a repl with the flake loaded
```

`make` picks the host from `hostname -s`, so run it on the machine you are
configuring, or override it:

```sh
make build HOSTNAME=lpws
```

## bootstrapping a new machine

<details>
<summary><b>1. install nix</b></summary>

the [determinate systems installer](https://github.com/DeterminateSystems/nix-installer)
enables flakes out of the box and uninstalls cleanly, which the upstream
installer does not.

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

open a new shell afterwards so `nix` lands on your `PATH`.

</details>

<details>
<summary><b>2. set the hostname to match a host in the flake</b></summary>

on macos all three of these matter, and they drift apart easily:

```sh
sudo scutil --set ComputerName lpws
sudo scutil --set LocalHostName lpws
sudo scutil --set HostName lpws
```

</details>

<details>
<summary><b>3. install the macos prerequisites</b></summary>

nix-darwin drives homebrew but does not install it, and the command line tools
are needed before anything will compile.

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

</details>

<details>
<summary><b>4. apply</b></summary>

```sh
git clone git@github.com:levivannoort/nix.git ~/personal/nix
cd ~/personal/nix
make switch
```

on the first run `make switch` uses `nix run nix-darwin -- switch`, because
`darwin-rebuild` does not exist yet. afterwards it is on your `PATH`.

</details>

## things worth knowing

**homebrew is additive right now.** `homebrew.onActivation.cleanup` is `"none"`,
so casks installed by hand are left alone. to make it fully declarative,
reconcile `modules/darwin/homebrew.nix` against `brew list` first, then set it
to `"uninstall"`. the next switch after that change removes every cask and
formula not declared in the file.

**the terminal is ghostty.** `modules/home/programs/ghostty` writes
`~/.config/ghostty/config` as a literal file rather than through
`programs.ghostty`, because ghostty repeats the `palette` key sixteen times and
a nix attrset cannot hold duplicate keys. the app itself comes from the
homebrew cask so it lands in `/Applications` and can be pinned to the dock.

**the font is built from source.** ghostty asks for `SFMono Nerd Font`. apple
does not redistribute sf mono and nerd fonts ships no patched build, so there
is no nixpkgs attribute and no homebrew cask (`brew search sf-mono` only offers
a ligaturized variant). `pkgs/sf-mono-nerd-font` fetches the patched otf files
and the flake overlay exposes them as `pkgs.sf-mono-nerd-font`.

**unfree packages are allowed.** terraform, packer and vscode resolve because
`modules/shared/nix.nix` sets `nixpkgs.config.allowUnfree`.

**inputs move together.** home-manager is pinned to `release-25.05` to match
nixpkgs. tracking home-manager master against a stable nixpkgs is the single
most common source of evaluation breakage in a config like this, so bump both
or neither.

**`nix flake check` is the real gate.** the `checks` output evaluates all three
hosts, which is what catches option names that were renamed or removed
upstream. ci additionally builds each host, because evaluation proves the
config is well formed but not that every derivation compiles.

**mise is gone.** it used to pin versions of go, terraform, kubectl, helm and
twenty others that nix now owns. two version managers fighting over the same
binaries is worse than either alone, so `flake.lock` is the single source of
truth.

**vagrant is linux only.** its ruby grpc dependency does not build on
aarch64-darwin under nixpkgs 25.05, and vagrant on apple silicon has no usable
provider regardless. use the `vmte` host or plain qemu on macos.

## migrating from ~/.dotfiles

the stow-based repo at `~/.dotfiles` is superseded by this one. what moved:

| was | is now |
| :-- | :----- |
| `ghostty/.config/ghostty/config` | `modules/home/programs/ghostty` |
| `zsh/.zshrc` prompt, aliases, exports, history | `modules/home/programs/zsh` |
| `tmux/.tmux.conf` | `modules/home/programs/tmux` |
| `git/.gitconfig`, `git/.gitignore` | `modules/home/programs/git` |
| `k9s/.config/k9s` config, aliases, skin | `modules/home/programs/k9s` |
| `fzf/.fzf.zsh` | `modules/home/programs/fzf` shell integration |
| `osx/osx.zsh` defaults | `modules/darwin/system.nix` |
| `brew/.config/brew/Brewfile` cli tools | `modules/home/packages/` |
| `brew/.config/brew/Brewfile` casks | `modules/darwin/homebrew.nix` |
| `mise/.config/mise/config.toml` | dropped, see above |
| hand-installed `~/Library/Fonts` | `pkgs/sf-mono-nerd-font` |

deliberately left behind, because none of it belongs in a public repo or in
nix: the `pass` store and its private remote, `aws/template/config` (a
placeholder, real profiles are machine-local), and the digital ocean kubectx
script, which hardcodes cluster names.

once `make switch` has run, unstow the old packages so the symlinks stop
shadowing what home-manager writes:

```sh
stow --dir ~/.dotfiles --target ~ --delete brew git k9s osx tmux zsh fzf ghostty
```
