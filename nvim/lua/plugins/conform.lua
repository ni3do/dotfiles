return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			nix = { "nil_ls" },
			tex = { "tex-fmt" },
		},
		formatters = {
			["tex-fmt"] = { -- Use brackets here
				append_args = { "--wraplen", "120" },
			},
		},

		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
