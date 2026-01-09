{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  programs.nvf = {
    enable = true;
    settings.vim = {
      enableLuaLoader = true;

      lazy.plugins.vim-puppet.package = pkgs.vimPlugins.vim-puppet;
      lazy.plugins.vim-twig.package = pkgs.vimPlugins.vim-twig;
      treesitter.grammars = [
        pkgs.vimPlugins.nvim-treesitter-parsers.puppet
      ];
      treesitter = {
        enable = true;
        addDefaultGrammars = true;
        fold = true;
        autotagHtml = true;
      };
      visuals = {
        fidget-nvim.enable = true;
        indent-blankline.enable = true;
      };

      utility = {
        images.image-nvim.enable = true;
        images.image-nvim.setupOpts.backend = "kitty";
        ccc.enable = true;
      };

      ui = {
        illuminate.enable = true;
        noice.enable = true;
        modes-nvim = {
          enable = true;
          setupOpts.line_opacity.visual = 0.8;
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        #lspconfig.enable = true;
        trouble.enable = true;
        null-ls.enable = true;
        otter-nvim.enable = true;
        lspsaga.enable = true;
        servers.nixd.settings.nil.nix.autoArchive = true;
        servers.erlang-language-platform = {
          enable = true;
          cmd = [(getExe pkgs.erlang-language-platform) "server"];
          filetypes = ["erlang"];
          root_markers = [".git" "erlang.mk" "rebar.config"];
          package = pkgs.erlang-language-platform;
        };
      };
      diagnostics.config.virtual_lines = true;
      luaConfigRC.enablelines =
        # lua
        ''
          vim.diagnostic.config({
            virtual_text = {
              severity = {
                max = vim.diagnostic.severity.WARN,
              },
            },
            virtual_lines = {
              severity = {
                min = vim.diagnostic.severity.ERROR,
              },
            },
          })
        '';
      statusline.lualine.enable = true;
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        sourcePlugins = {
          ripgrep.enable = true;
          spell.enable = true;
        };
      };
      formatter.conform-nvim.enable = true;
      diagnostics.nvim-lint.enable = true;
      options = {
        tabstop = 2;
        shiftwidth = 2;
      };
      languages = {
        ruby = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };
        yaml = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        ts = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };
        php = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        sql = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        nix = {
          enable = true;
          extraDiagnostics.enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        css = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        html = {
          enable = true;
          treesitter.enable = true;
        };
        python = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        r = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
      };
    };
  };
}
