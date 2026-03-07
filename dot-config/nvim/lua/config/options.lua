-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable automatic clipboard sync
vim.opt.clipboard = ""

-- Python LSP and tooling preferences
vim.g.lazyvim_python_lsp = "basedpyright" -- Use basedpyright (faster) or "pyright"
vim.g.lazyvim_python_ruff = "ruff" -- Use ruff for formatting/linting
