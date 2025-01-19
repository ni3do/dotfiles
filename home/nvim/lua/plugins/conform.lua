return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "black", "isort" },
      nix = { "nixfmt" },
    },

    formatters = {
      black = {
        prepend_args = { "--line-length", "120" },
      },
    },
  },
}
