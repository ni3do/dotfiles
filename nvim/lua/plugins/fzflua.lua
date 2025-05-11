return {
	"ibhagwan/fzf-lua",
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	keys = {
		{
			"<leader>nf",
			function()
				require("fzf-lua").files({ cwd = "~/repos/second-brain" })
			end,
			desc = "Find in Notes",
		},
		{
			"<leader>nt",
			function()
				local Path = require("plenary.path")
				local scan = require("plenary.scandir")
				local fzf = require("fzf-lua")

				local tasks = {}
				local base_path = vim.fn.expand("~/repos/second-brain")

				scan.scan_dir(base_path, {
					depth = nil,
					hidden = true,
					add_dirs = false,
					search_pattern = "%.md$",
					on_insert = function(entry)
						local filepath = Path:new(entry)
						local lines = filepath:readlines()
						for i, line in ipairs(lines) do
							if line:match("^%- %[ %]") or line:match("^%- %[ %] %d%d%d%d%-%d%d%-%d%d |") then
								local rel_path = vim.fn.fnamemodify(filepath:absolute(), ":~:.")
								table.insert(tasks, {
									display = string.format("%s:%d: %s", rel_path, i, line),
									path = filepath:absolute(),
									lnum = i,
								})
							end
						end
					end,
				})

				fzf.fzf_exec(
					vim.tbl_map(function(task)
						return task.display
					end, tasks),
					{
						prompt = "Open Tasks> ",
						actions = {
							default = function(selected)
								local choice = selected[1]
								local path, lnum = choice:match("^(.-):(%d+):")
								if path and lnum then
									vim.cmd("edit " .. path)
									vim.fn.cursor(tonumber(lnum), 0)
								end
							end,
						},
					}
				)
			end,
			desc = "Open Tasks Picker (FZF)",
		},
	},
}
