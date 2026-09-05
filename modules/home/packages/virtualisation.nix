{ pkgs }:

with pkgs;
[
  qemu
  vagrant
]
++ lib.optionals stdenv.isLinux [
  # libvirt has no usable darwin build; it was previously in the flat package
  # list and would break every macOS rebuild.
  libvirt
]
