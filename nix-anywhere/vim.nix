{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      enableLuaLoader = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        lspsaga.enable = true;
        lspconfig.enable = true;
        trouble.enable = true;
        null-ls.enable = true;
        otter-nvim.enable = true;
        servers.nixd.settings.nil.nix.autoArchive = true;
      };
      lazy.plugins."vim-twig" = {
        package = pkgs.vimPlugins.vim-twig;
      };
      lazy.plugins."vim-puppet" = {
        package = pkgs.vimPlugins.vim-puppet;
      };

      diagnostics.config.virtual_lines = true;
      luaConfigRC.enablelines =
        /*
        lua
        */
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
      autocomplete.nvim-cmp.enable = true;
      formatter.conform-nvim = {
        enable = true;
        setupOpts.fomatters_by_ft = {
          php = ["mago"];
        };
      };
      options = {
        tabstop = 2;
        shiftwidth = 2;
      };
      languages = {
        ruby = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        ts = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        sql = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        nix = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        css = {
          enable = true;
          lsp.enable = false;
          treesitter.enable = true;
          format.enable = false;
        };
        html = {
          enable = true;
          treesitter.enable = true;
        };
        python = {
          enable = true;
          format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        php = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
      };
    };
  };
}
