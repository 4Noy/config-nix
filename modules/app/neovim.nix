{ config, pkgs, ... }:

let
  vimPlugins = pkgs.vimPlugins;
in {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      python3
      python3Packages.pynvim
      python3Packages.python-lsp-server
      python3Packages.black
      nodePackages.typescript-language-server
      nodePackages.typescript
      nodePackages.prettier
      nodePackages.eslint
      clang-tools
      shellcheck
      shfmt
      stylua
    ];

    plugins = with vimPlugins; [
      tokyonight-nvim
      nvim-lspconfig
      nvim-treesitter
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      null-ls-nvim
      lualine-nvim
      telescope-nvim
      nvim-tree-lua
      gitsigns-nvim
      comment-nvim
    ];

    extraConfig = ''
      syntax on
      set number relativenumber
      set mouse=a
      set clipboard=unnamedplus
      set smartindent
      set expandtab
      filetype plugin indent on

      lua <<EOF
      local ok, tok = pcall(require, "tokyonight")
      if ok then
        vim.g.tokyonight_style = "storm"
        tok.setup({
          on_highlights = function(hl, c)
            hl.Comment = { fg = "#9ccf8a", italic = true }
          end
        })
        vim.cmd("colorscheme tokyonight")
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = { {name='nvim_lsp'}, {name='luasnip'}, {name='buffer'}, {name='path'} }
      })

      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")

      local on_attach = function(client, bufnr)
        local opts = { noremap=true, silent=true }
        vim.api.nvim_buf_set_keymap(bufnr,'n','gd','<cmd>lua vim.lsp.buf.definition()<CR>',opts)
        vim.api.nvim_buf_set_keymap(bufnr,'n','K','<cmd>lua vim.lsp.buf.hover()<CR>',opts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for _, lsp in ipairs({"pylsp","clangd","ts_ls","lua_ls","bashls","jsonls","yamlls"}) do
        lspconfig[lsp].setup({ on_attach = on_attach, capabilities = capabilities })
      end

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.shfmt,
        },
        on_attach = on_attach,
      })
      EOF
    '';
  };
}
