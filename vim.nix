{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      enableLuaLoader = true;
      lsp = {
        enable = true;
        lspsaga.enable = true;
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
          require'lspconfig'.glsl_analyzer.setup{}
          require'lspconfig'.erlangls.setup{}
        '';
      statusline.lualine.enable = true;
      autocomplete.nvim-cmp.enable = true;
      formatter.conform-nvim.enable = true;
      options = {
        tabstop = 2;
        shiftwidth = 2;
      };
      languages = {
        ts = {
          enable = true;
          #format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        php = {
          enable = true;
          lsp.enable = true;
          lsp.server = "phan";
          treesitter.enable = true;
        };
        sql = {
          enable = true;
          #format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        nix = {
          enable = true;
          #format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        css = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          #format.enable = false;
        };
        html = {
          enable = true;
          treesitter.enable = true;
        };
        python = {
          enable = true;
          #format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        r = {
          enable = true;
          #format.enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
      };
    };
  };
}
