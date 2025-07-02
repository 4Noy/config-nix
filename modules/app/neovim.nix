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
      lua-language-server
      clang-tools
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      openjdk
      editorconfig-core-c
      black
    ];

    plugins = with vimPlugins; [
      tokyonight-nvim
      lualine-nvim
      bufferline-nvim
      telescope-nvim
      nvim-tree-lua
      gitsigns-nvim
      vim-fugitive
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      null-ls-nvim
      editorconfig-nvim
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

      lua << EOF
        -- Protected require
        local function safe_require(name)
          local ok, mod = pcall(require, name)
          if ok then return mod end
        end

        -- Colorscheme
        vim.cmd.colorscheme("tokyonight")

        -- UI Plugins
        safe_require("lualine")?.setup { options = { theme = "tokyonight" } }
        safe_require("bufferline")?.setup{}
        safe_require("gitsigns")?.setup{}
        safe_require("nvim-tree")?.setup{}
        safe_require("telescope")?.setup{}
        safe_require("editorconfig")?.setup{}
        safe_require("Comment")?.setup{}

        -- Treesitter
        safe_require("nvim-treesitter.configs")?.setup {
          highlight = { enable = true },
          indent = { enable = true },
        }

        -- Mason & LSP
        local mason = safe_require("mason")
        local mason_lspconfig = safe_require("mason-lspconfig")
        local lspconfig = safe_require("lspconfig")

        mason?.setup()
        mason_lspconfig?.setup {
          ensure_installed = {
            "pyright", "clangd", "lua_ls", "tsserver",
            "bashls", "jsonls", "yamlls", "jdtls"
          }
        }

        local capabilities = safe_require("cmp_nvim_lsp")?.default_capabilities()

        for _, server in ipairs(mason_lspconfig?.get_installed_servers() or {}) do
          lspconfig[server].setup {
            capabilities = capabilities,
          }
        end

        -- nvim-cmp
        local cmp = safe_require("cmp")
        local luasnip = safe_require("luasnip")

        cmp?.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip and luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip and luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm { select = true },
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
          }
        }

        -- null-ls
        local null_ls = safe_require("null-ls")
        null_ls?.setup {
          sources = {
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.eslint,
          },
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function() vim.lsp.buf.format() end,
              })
            end
          end,
        }

        -- TAB auto adapt
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "*",
          callback = function()
            local ft = vim.bo.filetype
            if ft == "make" or ft == "makefile" then
              vim.bo.expandtab = false
              vim.bo.tabstop = 4
              vim.bo.shiftwidth = 4
              vim.bo.softtabstop = 4
            elseif ft == "yaml" or ft == "json" or ft == "lua" then
              vim.bo.expandtab = true
              vim.bo.tabstop = 2
              vim.bo.shiftwidth = 2
              vim.bo.softtabstop = 2
            else
              vim.bo.expandtab = true
              vim.bo.tabstop = 4
              vim.bo.shiftwidth = 4
              vim.bo.softtabstop = 4
            end
          end
        })
      EOF
    '';
  };
}
