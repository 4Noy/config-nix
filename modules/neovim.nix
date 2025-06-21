{ root, config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      pyright
      rust-analyzer
      clang-tools
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.eslint
      nodePackages.prettier
    ];

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-treesitter.withAllGrammars
      lualine-nvim
      bufferline-nvim
      telescope-nvim
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      gitsigns-nvim
      nvim-tree-lua
      comment-nvim
      catppuccin-nvim
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
        require('lualine').setup { options = { theme = 'catppuccin' } }
        require'nvim-treesitter.configs'.setup { highlight = { enable = true }, indent = { enable = true } }
        require('telescope').setup{}
        require('gitsigns').setup()
        require("nvim-tree").setup()
      EOF
    '';
  };
}
