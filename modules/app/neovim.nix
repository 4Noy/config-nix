{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      lua-language-server
      pyright
      rust-analyzer
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
      comment-nvim

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
      vim-fugitive
    ];

    extraConfig = ''
      syntax on
      set number
      set relativenumber
      set mouse=a
      set clipboard=unnamedplus
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set smartindent

      lua << EOF
        require("catppuccin").setup({ flavour = "mocha" })
        vim.cmd.colorscheme "catppuccin"

        require("lualine").setup { options = { theme = "catppuccin" } }
        require("bufferline").setup{}
        require("gitsigns").setup()
        require("nvim-tree").setup()
        require("telescope").setup{}

        require("nvim-treesitter.configs").setup {
          highlight = { enable = true },
          indent = { enable = true },
        }

        require("Comment").setup()

        require("editorconfig").setup {}

        local lspconfig = require("lspconfig")
        local cmp = require("cmp")

        require("mason").setup()
        require("mason-lspconfig").setup {
          ensure_installed = {
            "pyright", "clangd", "lua_ls", "tsserver", "bashls", "jsonls", "yamlls", "jdtls"
          },
          automatic_installation = true,
        }

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local servers = { "pyright", "clangd", "tsserver", "bashls", "jsonls", "yamlls", "jdtls", "lua_ls" }
        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup { capabilities = capabilities }
        end

        cmp.setup {
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
            { name = "path" },
          }),
        }

        local null_ls = require("null-ls")
        null_ls.setup {
          sources = {
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.diagnostics.eslint,
          },
        }
      EOF
    '';
  };
}
