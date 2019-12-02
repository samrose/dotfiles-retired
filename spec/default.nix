# To apply this spec, run: `nix-env -rif spec`

{ pkgs ? import ../pkgs.nix {} }:

with pkgs;

let
  elixir-erlang-src = runCommand "elixir-erlang-src" {} ''
    mkdir $out
    ln -s ${elixir.src} $out/elixir
    ln -s ${erlang.src} $out/otp
  '';

  neovim-with-config = neovim.override {
    configure = {
      customRC = ''
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#sources#rust#racer_binary = "${rustracer}/bin/racer"
        let g:deoplete#sources#rust#rust_source_path = "${rustc.src}"
        let g:alchemist#elixir_erlang_src = "${elixir-erlang-src}"

        set title
        set nu
      '';

      packages.package.start = with vimPlugins; [
        alchemist-vim
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

[
  fzf
  git
  gocode
  neovim-with-config
  nix # must always be present
  rustracer
  which
]
