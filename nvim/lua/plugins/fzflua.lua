return {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	keys = {
		{
			"<leader>fn",
			function()
				require("fzf-lua").files({ cwd = "~/repos/second-brain" })
			end,
			desc = "Find in Notes",
		},
	},
}
