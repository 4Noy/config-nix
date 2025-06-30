{ config, pkgs, lib, ... }: {
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

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      catppuccin-nvim
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

      lua << EOF
        require('catppuccin').setup{ flavour = 'mocha' }
        vim.cmd.colorscheme 'catppuccin'
        require('lualine').setup{ options = { theme = 'catppuccin' } }
        require('bufferline').setup{}
        require('gitsigns').setup{}
        require('nvim-tree').setup{}
        require('telescope').setup{}
        require('editorconfig').setup{}
        require('Comment').setup{}

        require('nvim-treesitter.configs').setup{
          highlight={ enable=true },
          indent={ enable=true },
        }

        local mason = require('mason')
        mason.setup()
        require('mason-lspconfig').setup{
          ensure_installed = {
            'pyright', 'clangd', 'lua_ls', 'tsserver',
            'bashls', 'jsonls', 'yamlls', 'jdtls'
          }
        }

        local lsp = require('lspconfig')
        local caps = require('cmp_nvim_lsp').default_capabilities()
        for _, ls in ipairs(mason.lspconfig.get_installed_servers()) do
          lsp[ls].setup{ capabilities = caps }
        end

        require('cmp').setup{
          snippet={
            expand=function(args) require('luasnip').lsp_expand(args.body) end
          },
          mapping=require('cmp').mapping.preset.insert{
            ['<C-Space>'] = require('cmp').mapping.complete(),
            ['<CR>'] = require('cmp').mapping.confirm{ select=true },
          },
          sources={
            { name='nvim_lsp' },
            { name='luasnip' },
          }
        }

        require('null-ls').setup{
          sources={
            require('null-ls').builtins.formatting.black,
            require('null-ls').builtins.formatting.prettier,
            require('null-ls').builtins.diagnostics.eslint,
          }
        }

        require('nvim_comment').setup{}
      EOF
    '';
  };
}
