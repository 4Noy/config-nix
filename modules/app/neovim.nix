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
      editorconfig-vim
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
        local function safe_require(name)
          local ok, mod = pcall(require, name)
          return ok and mod or nil
        end

        local function try_setup(mod, opts)
          if type(mod) == "table" and type(mod.setup) == "function" then
            mod.setup(opts or {})
          end
        end

        -- Theme
        vim.cmd.colorscheme("tokyonight")

        -- UI Plugins
        try_setup(safe_require("lualine"), { options = { theme = "tokyonight" } })
        try_setup(safe_require("bufferline"))
        try_setup(safe_require("gitsigns"))
        try_setup(safe_require("nvim-tree"))
        try_setup(safe_require("telescope"))
        try_setup(safe_require("editorconfig"))
        try_setup(safe_require("Comment"))
        try_setup(safe_require("nvim-treesitter.configs"), {
          highlight = { enable = true },
          indent    = { enable = true },
        })

        -- Mason & LSPconfig
        local mason = safe_require("mason")
        local mlsp = safe_require("mason-lspconfig")
        local lspconfig = safe_require("lspconfig")
        local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")

        if mason then
          mason.setup()
        end

        if mlsp then
          local wanted = { "pyright", "clangd", "lua_ls", "tsserver", "bashls", "jsonls", "yamlls", "jdtls" }
          local available = mlsp.get_available_servers()
          local to_install = vim.tbl_filter(function(s) return vim.tbl_contains(available, s) end, wanted)

          mlsp.setup({ ensure_installed = to_install })

          local caps = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities()
          mlsp.setup_handlers({
            function(server)
              local cfg = {}
              if caps then cfg.capabilities = caps end
              lspconfig[server].setup(cfg)
            end
          })
        end

        -- Completion
        local cmp = safe_require("cmp")
        local luasnip = safe_require("luasnip")
        if cmp then
          cmp.setup({
            snippet = { expand = function(args) if luasnip then luasnip.lsp_expand(args.body) end end },
            mapping = cmp.mapping.preset.insert({
              ["<Tab>"] = cmp.mapping(function(f)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip and luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else f() end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(f)
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip and luasnip.jumpable(-1) then luasnip.jump(-1)
                else f() end
              end, { "i", "s" }),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<CR>"]     = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
              { name = "nvim_lsp" },
              { name = "luasnip"   },
              { name = "buffer"    },
              { name = "path"      },
            },
          })
        end

        -- null-ls formatting
        local null_ls = safe_require("null-ls")
        if null_ls then
          null_ls.setup({
            sources = {
              null_ls.builtins.formatting.black,
              null_ls.builtins.formatting.prettier,
              null_ls.builtins.diagnostics.eslint,
            },
          })

          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function() vim.lsp.buf.format({ async = false }) end,
          })
        end

        -- Adaptive Tab/Spaces
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "*",
          callback = function()
            local ft = vim.bo.filetype
            if ft == "make" or ft == "makefile" then
              vim.bo.expandtab   = false
              vim.bo.tabstop     = 4
              vim.bo.shiftwidth  = 4
              vim.bo.softtabstop = 4
            elseif ft == "yaml" or ft == "json" or ft == "lua" then
              vim.bo.expandtab   = true
              vim.bo.tabstop     = 2
              vim.bo.shiftwidth  = 2
              vim.bo.softtabstop = 2
            else
              vim.bo.expandtab   = true
              vim.bo.tabstop     = 4
              vim.bo.shiftwidth  = 4
              vim.bo.softtabstop = 4
            end
          end,
        })
      EOF
    '';
  };
}
