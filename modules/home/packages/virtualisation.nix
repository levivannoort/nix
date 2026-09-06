{ pkgs }:

with pkgs;
[
  qemu
]
++ lib.optionals stdenv.isLinux [
  # libvirt has no usable darwin build.
  libvirt

  # vagrant is linux-only here for two reasons: its ruby grpc dependency fails
  # to compile on aarch64-darwin under nixpkgs 25.05, and vagrant on apple
  # silicon has no usable provider anyway (virtualbox is x86-only). use the
  # nixos-vm host or plain qemu on macos instead.
  vagrant
]
