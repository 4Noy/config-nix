{ config, pkgs, lib, ... }:

let
  # raccourci pour plugins vim
  vimPlugins = pkgs.vimPlugins;
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      python313Full
      python313Packages.pynvim
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
      set expandtab
      set smartindent
      filetype plugin indent on

      "
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4

      lua << EOF
        -- Theme
        vim.cmd.colorscheme("tokyonight")

        -- Setup lualine
        require('lualine').setup {
          options = { theme = 'tokyonight' }
        }

        -- Setup plugins
        require('bufferline').setup{}
        require('gitsigns').setup{}
        require('nvim-tree').setup{}
        require('telescope').setup{}
        require('editorconfig').setup{}
        require('Comment').setup{}

        -- Treesitter
        require('nvim-treesitter.configs').setup {
          highlight = { enable = true },
          indent = { enable = true },
        }

        -- Mason
        local mason = require("mason")
        mason.setup()

        require("mason-lspconfig").setup {
          ensure_installed = {
            "pyright", "clangd", "lua_ls", "tsserver",
            "bashls", "jsonls", "yamlls", "jdtls"
          }
        }

        local lspconfig = require("lspconfig")
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
          lspconfig[server].setup {
            capabilities = capabilities,
          }
        end

        -- Setup nvim-cmp
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
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

        -- Setup null-ls
        local null_ls = require('null-ls')
        null_ls.setup {
          sources = {
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.eslint,
          },
          on_attach = function(client)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = 0, buffer = 0 })
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = 0,
                callback = function() vim.lsp.buf.format() end
              })
            end
          end,
        }

        -- Tab
        vim.api.nvim_create_autocmd({"FileType"}, {
          pattern = "*",
          callback = function()
            local ft = vim.bo.filetype
            if ft == "make" or ft == "makefile" then
              vim.bo.expandtab = false
              vim.bo.tabstop = 4
              vim.bo.shiftwidth = 4
              vim.bo.softtabstop = 4
            else
              vim.bo.expandtab = true
            end
          end
        })
      EOF
    '';
  };
}
