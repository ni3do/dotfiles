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
		-- stylua: ignore start
		-- { "<leader>nx", function() Snacks.picker({
		-- 	sources = {"files"},
		-- 	cwd = "~/repos/second-brain",
		-- 	pattern = "- [ ]*"
		-- }) end, desc = "Smart Find Files", },
		-- stylua: ignore end
		{
			"<leader>nx",
			function()
				local function find_tasks()
					local file_paths = {}
					local handle =
						io.popen("rg --vimgrep --no-heading --with-filename '^- \\[ \\].+$' ~/repos/second-brain")
					if handle then
						for line in handle:lines() do
							local file, line_num, col_num, text = line:match("^(.-):(%d+):(%d+):(.*)$")
							if file and line_num and text then
								table.insert(file_paths, {
									text = text,
									label = text,
									file = file,
									value = {
										filepath = file,
										linenum = tonumber(line_num),
									},
								})
							end
						end
						handle:close()
						Snacks.debug.log(file_paths)
						return file_paths
					end
				end

				require("snacks").picker({
					title = "Unfinished Tasks",
					items = find_tasks(),
					previewer = function(item, _, buffer)
						local filepath = item.value.filepath
						local linenum = item.value.linenum

						-- Load file contents
						local lines = vim.fn.readfile(filepath)
						vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

						-- Make sure buffer is unmodifiable (but temporarily allow changes for highlight)
						vim.bo[buffer].modifiable = true

						-- Highlight the matched line (0-indexed)
						vim.api.nvim_buf_add_highlight(buffer, -1, "TaskHighlight", linenum - 1, 0, -1)

						-- Optionally scroll to line
						vim.api.nvim_buf_call(buffer, function()
							vim.fn.cursor({ linenum, 1 })
						end)
					end,
					on_accept = function(item)
						vim.cmd("edit " .. item.value.filepath)
						vim.api.nvim_win_set_cursor(0, { item.value.linenum, 0 })
					end,
				})
			end,
			desc = "Show unfinished Tasks",
		},
		{
			"<leader>nt",
			function()
				local function find_tasks()
					local file_paths = {}
					local handle = io.popen("rg -- '^- \\[ \\].+$' ~/repos/second-brain")
					if handle then
						for line in handle:lines() do
							local file, value = line:match("^(.-):%s*(.+)$")
							if file and value then
								table.insert(file_paths, {
									text = value,
									file = file,
								})
							end
						end
						handle:close()
						Snacks.debug.log(file_paths)
						return file_paths
					end
				end
				Snacks.picker.grep({
					finder = find_tasks,
				})
			end,
			desc = "Show unfinished Tasks",
		},
		{
			"<leader>ni",
			function()
				local function find_tasks()
					local tasks = {}
					local handle = io.popen("rg -- '^- \\[ \\] \\d{2}-\\d{2}-\\d{2} \\| .+$' ~/repos/second-brain")
					if handle then
						for line in handle:lines() do
							table.insert(tasks, { text = line, file = line })
						end
						handle:close()
					end
					Snacks.picker.files({
						finder = function()
							return tasks
						end,
					})
				end
			end,
			desc = "Show tasks with due dates",
		},
		{
			"<leader>nd",
			function()
				local function find_tasks()
					local tasks = {}
					local today = os.date("%y-%m-%d")
					local handle =
						io.popen("rg --pcre2 '^- \\[ \\] (\\d{2}-\\d{2}-\\d{2}) \\| .+$' ~/repos/second-brain")
					if handle then
						for line in handle:lines() do
							local date = string.match(line, "%d%d%-%d%d%-%d%d")
							if date and date <= today then
								table.insert(tasks, { text = line, file = line })
							end
						end
						handle:close()
					end
					Snacks.picker.files({
						finder = function()
							return tasks
						end,
					})
				end
			end,
			desc = "Tasks due today or earlier",
		},
		{
			"<leader>nw",
			function()
				local function find_tasks()
					local tasks = {}
					local date_regex = ""
					for i = 0, 6 do
						local day = os.date("%d-%m-%y", os.time() + (i * 86400))
						date_regex = date_regex .. string.format("- \\[ \\] %s \\|", day)
						if i < 6 then
							date_regex = date_regex .. "|"
						end
					end
					local cmd = string.format("rg --pcre2 '%s' ~/repos/second-brain", date_regex)
					local handle = io.popen(cmd)
					if handle then
						for line in handle:lines() do
							table.insert(tasks, { text = line, file = line })
						end
						handle:close()
					end
					Snacks.picker.files({
						finder = function()
							return tasks
						end,
					})
				end
				find_tasks()
			end,
			desc = "Tasks due this week",
		},
	},
}
