{
  description = "kradalby's Neovim distribution";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Plugins not available in nixpkgs
    "vim:vim-plist" = {
      url = "github:darfink/vim-plist";
      flake = false;
    };

    "vim:github-coauthors.nvim" = {
      url = "github:cwebster2/github-coauthors.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  } @ inputs:
    {
      overlays.default = final: prev: let
        pkgs = import nixpkgs {
          inherit (prev) system;
        };

        # Build plugins not available in nixpkgs from flake inputs
        buildPlugin = n: v:
          pkgs.vimUtils.buildVimPlugin {
            name = pkgs.lib.strings.removePrefix "vim:" n;
            src = v.outPath;
            namePrefix = "";
            doCheck = false;
          };

        flakePlugins =
          pkgs.lib.mapAttrsToList buildPlugin
          (pkgs.lib.filterAttrs (n: _: pkgs.lib.strings.hasPrefix "vim:" n) inputs);

        neovim-nix-lua-conf = pkgs.writeText "nix.lua" ''
          vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/${
            if pkgs.stdenv.isDarwin
            then "libsqlite3.dylib"
            else "libsqlite3.so"
          }"
        '';

        neovim-kradalby-luaconfig = pkgs.stdenv.mkDerivation rec {
          name = "neovim-kradalby-luaconfig";
          src = pkgs.nix-gitignore.gitignoreSource [] ./.;
          phases = "installPhase";
          installPhase = ''
            mkdir -p $out/lua
            cp ${neovim-nix-lua-conf} $out/lua/nix.lua
            cp -r ${src}/init.lua $out/init.lua
            cp -r ${src}/lua/* $out/lua/.
          '';
        };
      in {
        neovim-kradalby = pkgs.neovim.override {
          viAlias = true;
          vimAlias = true;
          withNodeJs = false;

          configure = {
            packages.kradalby = {
              start =
                (with pkgs.vimPlugins; [
                  # Treesitter (all grammars, minus tlaplus due to nixpkgs bug)
                  # See: https://github.com/NixOS/nixpkgs/issues/341442
                  (nvim-treesitter.withPlugins (_:
                    builtins.filter (g: !(pkgs.lib.hasInfix "tlaplus" (pkgs.lib.getName g)))
                    pkgs.tree-sitter.allGrammars))

                  # Completion
                  blink-cmp

                  # LSP
                  SchemaStore-nvim

                  # Formatting & Linting
                  conform-nvim
                  nvim-lint

                  # Telescope
                  telescope-nvim
                  telescope-fzf-native-nvim
                  plenary-nvim

                  # UI
                  tokyonight-nvim
                  nvim-web-devicons
                  mini-nvim

                  # Git
                  gitsigns-nvim

                  # Editor
                  todo-comments-nvim
                  nvim-neoclip-lua
                  sqlite-lua
                ])
                ++ flakePlugins;
            };

            customRC = ''
              set runtimepath^=${neovim-kradalby-luaconfig}
              luafile ${neovim-kradalby-luaconfig}/init.lua
            '';
          };
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
      in {
        packages = {
          inherit (pkgs) neovim-kradalby;
          default = pkgs.neovim-kradalby;
        };

        apps.neovim-kradalby = flake-utils.lib.mkApp {drv = pkgs.neovim-kradalby;};
        apps.default = flake-utils.lib.mkApp {drv = pkgs.neovim-kradalby;};
      }
    );
}
