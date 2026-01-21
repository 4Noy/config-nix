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

      # Français
      hunspell
      hunspellDicts.fr-any

      # LSP
      ltex-ls
      texlab
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
      none-ls-nvim
      lualine-nvim
      telescope-nvim
      nvim-tree-lua
      gitsigns-nvim
      comment-nvim
    ];

    extraConfig = ''
      " ========================
      " BASE
      " ========================
      syntax on
      set number relativenumber
      set mouse=a
      set clipboard=unnamedplus
      set smartindent
      set expandtab
      filetype plugin indent on

      " ========================
      " ORTHOGRAPHE FRANÇAISE (HUNSPELL)
      " ========================
      set spell
      set spelllang=fr
      set spellsuggest=best,9

      autocmd FileType markdown,text,gitcommit,tex,plaintex setlocal spell

      " Raccourcis orthographe
      nnoremap ]s ]s
      nnoremap [s [s
      nnoremap z= z=
      nnoremap zg zg
      nnoremap zw zw

      lua <<EOF
      -- ========================
      -- THEME
      -- ========================
      local ok, tok = pcall(require, "tokyonight")
      if ok then
        vim.g.tokyonight_style = "storm"
        tok.setup({
          on_highlights = function(hl)
            hl.Comment = { fg = "#9ccf8a", italic = true }
          end
        })
        vim.cmd.colorscheme("tokyonight")
      end

      -- ========================
      -- COMPLETION
      -- ========================
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      -- ========================
      -- LSP
      -- ========================
      local lspconfig = require("lspconfig")

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      for _, lsp in ipairs({
        "pylsp",
        "clangd",
        "ts_ls",
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
      }) do
        if lspconfig[lsp] then
          lspconfig[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end
      end

      -- ========================
      -- LTEX (GRAMMAIRE FR)
      -- ========================
      lspconfig.ltex.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "markdown", "text", "gitcommit", "tex", "plaintex" },
        settings = {
          ltex = {
            language = "fr",
            additionalRules = { enablePickyRules = true },
            diagnosticSeverity = "information",
          },
        },
      })

      -- ========================
      -- TEXLAB
      -- ========================
      lspconfig.texlab.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "tex", "plaintex" },
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = true,
            },
          },
        },
      })
      EOF
    '';
  };
}
