-- Enable LazyVim's Python extra which includes:
-- - LSP: pyright or basedpyright
-- - Formatting & Linting: ruff
-- - Debugging: nvim-dap-python
-- - Virtual env management: venv-selector
return {
  -- Import the Python language extra
  { import = "lazyvim.plugins.extras.lang.python" },
}
