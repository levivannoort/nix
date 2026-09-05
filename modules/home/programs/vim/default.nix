{ ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      ignorecase = true;
      smartcase = true;
    };

    extraConfig = ''
      set nocompatible
      set hidden
      set incsearch
      set clipboard=unnamedplus
      syntax on
      filetype plugin indent on
    '';
  };
}
