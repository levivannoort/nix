# apple does not redistribute sf mono, and nerd fonts does not ship a patched
# build of it, so there is no nixpkgs attribute and no homebrew cask for this
# family (`brew search sf-mono` only offers the ligaturized variant). these are
# the same "SFMono ... Nerd Font Complete.otf" files that were previously
# copied into ~/Library/Fonts by hand.
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "sf-mono-nerd-font";
  version = "0-unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "epk";
    repo = "SF-Mono-Nerd-Font";
    rev = "ebd4255167f1b9105cfdf5694ea9a474f08a51c3";
    hash = "sha256-h2u3s8jU4IKtQ1fZKRVjR+BvYjGZ9n0QDXkddcRB1u4=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/share/fonts/opentype *.otf
    runHook postInstall
  '';

  meta = {
    description = "sf mono patched with nerd font glyphs, family name 'SFMono Nerd Font'";
    homepage = "https://github.com/epk/SF-Mono-Nerd-Font";
    # apple's sf mono license permits use but restricts redistribution, hence
    # unfree rather than a permissive spdx id.
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
