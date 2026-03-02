{
  description = "kradalby's Neovim distribution";
  inputs =
    # let
    #   nvimPlugin = ghurl: let
    #     pluginName = builtins.elemAt (builtins.split "/" ghurl) 1;
    #   in {
    #     "name" = "vim:${pluginName}";
    #     "value" = {
    #       url = "github:${ghurl}";
    #       flake = false;
    #     };
    #   };
    #
    #   nvimPluginsDef = builtins.listToAttrs (builtins.map nvimPlugin [
    #     "nvim-dap"
    #     "nvim-dap-go"
    #     "nvim-dap-python"
    #     "rcarriga/nvim-dap-ui"
    #
    #     # Libraries/Shared stuff
    #     "plenary.nvim"
    #   ]);
    # in
    {
      flake-utils.url = "github:numtide/flake-utils";

      flake-compat = {
        url = "github:edolstra/flake-compat";
        flake = false;
      };

      nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

      # "vim:" = {
      #   url = "github:";
      #   flake = false;
      # };

      "vim:nvim-colorizer.lua" = {
        url = "github:catgoose/nvim-colorizer.lua";
        flake = false;
      };

      "vim:conform.nvim" = {
        url = "github:stevearc/conform.nvim";
        flake = false;
      };

      "vim:nvim-lint" = {
        url = "github:mfussenegger/nvim-lint";
        flake = false;
      };

      "vim:schemastore.nvim" = {
        url = "github:b0o/schemastore.nvim";
        flake = false;
      };

      "vim:nvim-autopairs" = {
        url = "github:windwp/nvim-autopairs";
        flake = false;
      };

      "vim:mini.nvim" = {
        url = "github:echasnovski/mini.nvim";
        flake = false;
      };

      "vim:vim-plist" = {
        url = "github:darfink/vim-plist";
        flake = false;
      };

      "vim:nvim-web-devicons" = {
        url = "github:nvim-tree/nvim-web-devicons";
        flake = false;
      };

      "vim:tokyonight.nvim" = {
        url = "github:folke/tokyonight.nvim";
        flake = false;
      };

      "vim:nvim-neoclip.lua" = {
        url = "github:AckslD/nvim-neoclip.lua";
        flake = false;
      };

      "vim:sqlite.lua" = {
        url = "github:kkharji/sqlite.lua";
        flake = false;
      };

      "vim:gitsigns.nvim" = {
        url = "github:lewis6991/gitsigns.nvim";
        flake = false;
      };

      # "vim:trouble.nvim" = {
      #   url = "github:folke/trouble.nvim";
      #   flake = false;
      # };

      "vim:todo-comments.nvim" = {
        url = "github:folke/todo-comments.nvim";
        flake = false;
      };

      # "vim:nvim-nio" = {
      #   url = "github:nvim-neotest/nvim-nio";
      #   flake = false;
      # };
      #
      # "vim:nvim-dap" = {
      #   url = "github:mfussenegger/nvim-dap";
      #   flake = false;
      # };
      #
      # "vim:nvim-dap-ui" = {
      #   url = "github:rcarriga/nvim-dap-ui";
      #   flake = false;
      # };
      #
      # "vim:nvim-dap-python" = {
      #   url = "github:mfussenegger/nvim-dap-python";
      #   flake = false;
      # };
      #
      # "vim:nvim-dap-go" = {
      #   url = "github:leoluz/nvim-dap-go";
      #   flake = false;
      # };
      #
      # "vim:nvim-dap-virtual-text" = {
      #   url = "github:theHamsta/nvim-dap-virtual-text";
      #   flake = false;
      # };
      #
      # "vim:telescope-dap.nvim" = {
      #   url = "github:nvim-telescope/telescope-dap.nvim";
      #   flake = false;
      # };

      "vim:plenary.nvim" = {
        url = "github:nvim-lua/plenary.nvim";
        flake = false;
      };

      "vim:telescope.nvim" = {
        url = "github:nvim-telescope/telescope.nvim";
        flake = false;
      };

      "vim:github-coauthors.nvim" = {
        url = "github:cwebster2/github-coauthors.nvim";
        flake = false;
      };

      # These require special treatment (ie, compilation), so we can't load them in bulk
      "telescope-fzf-native.nvim" = {
        url = "github:nvim-telescope/telescope-fzf-native.nvim";
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
      overlay = final: prev: let
        pkgs = import nixpkgs {
          inherit (prev) system;
          # overlays = [neovim-nightly-overlay.overlay];
        };

        # Build Vim plugin flake inputs into a list of Nix packages
        # Helper function to create a basic plugin
        buildPlugin = n: v: pkgs.vimUtils.buildVimPlugin {
          name = pkgs.lib.strings.removePrefix "vim:" n;
          src = v.outPath;
          namePrefix = "";
          # Temporarily disable checks while we implement proper dependencies
          doCheck = false;
        };

        # Build all plugins first
        basePlugins = pkgs.lib.mapAttrsToList buildPlugin (pkgs.lib.filterAttrs (n: v: pkgs.lib.strings.hasPrefix "vim:" n) inputs);

        # For debugging, let's see what plugin names we actually have
        pluginNames = map (plugin: plugin.name) basePlugins;

        # Convert to attribute set for easy referencing
        pluginSet = pkgs.lib.listToAttrs (map (plugin: pkgs.lib.nameValuePair plugin.name plugin) basePlugins);

        # For now, use basic plugins to test if the build works
        vimPackages = basePlugins;

        telescopeFzfNative = pkgs.vimUtils.buildVimPlugin {
          name = "telescope-fzf-native.nvim";
          src = inputs."telescope-fzf-native.nvim".outPath;
          namePrefix = "";
          buildPhase = ''
            make
          '';
        };

        neovim-nix-lua-conf = pkgs.writeText "nix.lua" ''
          vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/${
            if pkgs.stdenv.isDarwin
            then "libsqlite3.dylib"
            else "libsqlite3.so"
          }"
        '';

        # TODO: Only copy *.lua files, maybe with `nix-filter`
        # Make a derivation containing only Neovim Lua config
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
        # Wrap Neovim with custom plugins and config
        neovim-kradalby = pkgs.neovim.override {
          viAlias = true;
          vimAlias = true;
          withNodeJs = false;

          configure = {
            packages.kradalby = with pkgs.vimPlugins; {
              start =
                [
                  # Filter out tlaplus grammar due to nixpkgs bug with scoped npm package names
                  # The @tlaplus/tree-sitter-tlaplus package causes grammarToPlugin to fail
                  # See: https://github.com/NixOS/nixpkgs/issues/341442
                  (nvim-treesitter.withPlugins (_:
                    builtins.filter (g: !(pkgs.lib.hasInfix "tlaplus" (pkgs.lib.getName g)))
                      pkgs.tree-sitter.allGrammars
                  ))
                  telescopeFzfNative
                  blink-cmp
                ]
                ++ vimPackages;
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
          overlays = [self.overlay];
        };
      in rec {
        packages = with pkgs; {
          inherit neovim-kradalby;

          default = neovim-kradalby;
        };

        defaultPackage = packages.neovim-kradalby;
        apps.neovim-kradalby = flake-utils.lib.mkApp {drv = packages.neovim-kradalby;};
        defaultApp = apps.neovim-kradalby;

        overlays.default = self.overlay;
      }
    );
}
