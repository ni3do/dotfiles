return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		render_modes = { "n", "c", "t" },
	},
	completions = { blink = { enabled = true } },

	latex = {
		-- Turn on / off latex rendering.
		enabled = true,
		-- Executable used to convert latex formula to rendered unicode.
		converter = "python3 -m pylatexenc.latex2text",
	},
}
