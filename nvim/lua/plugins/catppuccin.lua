return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			custom_highlights = function(colors)
				return {
					FlashBackdrop = { fg = colors.overlay0 },
					FlashLabel = { fg = colors.blue, bg = bg, style = { "bold" } },
					FlashMatch = { fg = colors.base, bg = colors.mauve },
					FlashCurrent = { fg = colors.maroon, bg = bg },
					FlashPrompt = { link = "NormalFloat" },
				}
			end,
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme catppuccin-macchiato]])
	end,
}
