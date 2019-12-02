{ pkgs ? import ../pkgs.nix {} }:
with pkgs;

let
  inherit (perlPackages) vidir;
  neovim-with-config = neovim.override {
    configure = {
      customRC = ''
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#sources#rust#racer_binary='${rustracer}/bin/racer'
        let g:deoplete#sources#rust#rust_source_path='/home/samrose/Desktop/rust/src'
        set title
        set nu
      '';
      packages.package.start = with vimPlugins; [
        deoplete-nvim
        deoplete-jedi
        deoplete-go
        deoplete-rust
        fzf
        vim-elixir
        vim-fireplace
        vim-go
        vim-nix
        vim-parinfer
      ];
    };

    viAlias = true;

    withPython3 = true;
    withRuby = false;
  };
in

mkShell {


  buildInputs = [
    cargo
    elixir
    fzf
    git
    go
    gocode
    go2nix
    neovim-with-config
    rustc
    rustracer
    which
  ];

}
