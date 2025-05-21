return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = false,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	--   -- refer to `:h file-pattern` for more examples
	--   "BufReadPre path/to/my-vault/*.md",
	--   "BufNewFile path/to/my-vault/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
	},
	---@module 'obsidian'
	---@type obsidian.config.ClientOpts
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/repos/second-brain",
			},
		},
		new_notes_location = "inbox",
		completion = {
			-- Enables completion using nvim_cmp
			nvim_cmp = false,
			-- Enables completion using blink.cmp
			blink = true,
		},
		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
			name = "snacks.pick",
		},
		ui = { enable = false },
	},
	keys = {
		{ "<leader>nf", "<cmd>ObsidianQuickSwitch<CR>", desc = "Find Note" },
		{ "<leader>ns", "<cmd>ObsidianQuickSwitch inbox/scratchpad.md<CR>", desc = "Open Scratchpad" },
		{ "<leader>nw", "<cmd>ObsidianWorkspace<CR>", desc = "Switch workspace" },
		{ "<leader>na", "<cmd>ObsidianNew<CR>", desc = "Create new Note" },
	},
}
