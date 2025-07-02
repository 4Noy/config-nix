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
          if ok then return mod end
          return nil
        end

        vim.cmd.colorscheme("tokyonight")

        local mod = safe_require("lualine")
        if mod then mod.setup { options = { theme = "tokyonight" } } end

        mod = safe_require("bufferline")
        if mod then mod.setup {} end

        mod = safe_require("gitsigns")
        if mod then mod.setup {} end

        -- Le require correct pour nvim-tree
        local tree = safe_require("nvim-tree")
        if tree then tree.setup {} end

        mod = safe_require("telescope")
        if mod then mod.setup {} end

        mod = safe_require("editorconfig")
        if mod then mod.setup {} end

        mod = safe_require("Comment")
        if mod then mod.setup {} end

        mod = safe_require("nvim-treesitter.configs")
        if mod then mod.setup { highlight = { enable = true }, indent = { enable = true } } end

        local mason = safe_require("mason")
        local mason_lsp = safe_require("mason-lspconfig")
        local lspconfig = safe_require("lspconfig")
        if mason then mason.setup() end
        if mason_lsp then
          mason_lsp.setup {
            ensure_installed = { "pyright","clangd","lua_ls","tsserver","bashls","jsonls","yamlls","jdtls" }
          }
        end

        local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")
        local caps = cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities()

        if mason_lsp and lspconfig and caps then
          for _, srv in ipairs(mason_lsp.get_installed_servers()) do
            lspconfig[srv].setup { capabilities = caps }
          end
        end

        local cmp = safe_require("cmp")
        local luasnip = safe_require("luasnip")
        if cmp then
          cmp.setup {
            snippet = {
              expand = function(args)
                if luasnip then luasnip.lsp_expand(args.body) end
              end,
            },
            mapping = cmp.mapping.preset.insert {
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip and luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
              end, {"i","s"}),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip and luasnip.jumpable(-1) then luasnip.jump(-1)
                else fallback() end
              end, {"i","s"}),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<CR>"] = cmp.mapping.confirm { select = true },
            },
            sources = {
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            },
          }
        end

        local null_ls = safe_require("null-ls")
        if null_ls then
          null_ls.setup {
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
        end

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
          end,
        })
      EOF
    '';
  };
}
