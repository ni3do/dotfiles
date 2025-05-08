--------------------------------
-- Utilities Keymaps
--------------------------------
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file (normal mode)" })
vim.keymap.set("i", "<C-s>", "<ESC><cmd>w<CR>", { desc = "Save file (insert mode)" })

--------------------------------
-- Note Taking Keymaps
--------------------------------
vim.keymap.set("n", "<leader>na", function()
	vim.ui.input({ prompt = "Enter new file name: " }, function(input)
		if input and input ~= "" then
			local inbox_path = vim.fn.expand("~/repos/second-brain/inbox/")
			local full_path = inbox_path .. "/" .. input

			local file = io.open(full_path, "w")
			if file then
				file:close()
				vim.cmd("edit " .. vim.fn.fnameescape(full_path))
			else
				vim.notify("Could not create file: " .. full_path, vim.log.levels.ERROR)
			end
		end
	end)
end, { desc = "Create new inbox file" })

vim.keymap.set("n", "<leader>ns", function()
	local scratchpad_path = vim.fn.expand("~/repos/second-brain/inbox/scratchpad.md")
	local file = io.open(scratchpad_path, "r")
	if file then
		file:close()
		vim.cmd("edit " .. vim.fn.fnameescape(scratchpad_path))
	else
		vim.notify("Could not find scratchpad file at  " .. scratchpad_path, vim.log.levels.ERROR)
	end
end, { desc = "Go to Notes Scratchpad" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Show diagnostics in floating window" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "Format current file with fallback" })

--------------------------------
-- Harpoon Keymaps
--------------------------------
local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>m", function()
	harpoon:list():add()
end, { desc = "Add file to Harpoon list" })

vim.keymap.set("n", "<C-r>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon quick menu" })

vim.keymap.set("n", "<C-a>", function()
	harpoon:list():select(1)
end, { desc = "Harpoon: Go to file 1" })

vim.keymap.set("n", "<C-d>", function()
	harpoon:list():select(2)
end, { desc = "Harpoon: Go to file 2" })

vim.keymap.set("n", "<C-f>", function()
	harpoon:list():select(3)
end, { desc = "Harpoon: Go to file 3" })

vim.keymap.set("n", "<C-g>", function()
	harpoon:list():select(4)
end, { desc = "Harpoon: Go to file 4" })

-- vim.keymap.set("n", "<C-S-P>", function()
-- 	harpoon:list():prev()
-- end, { desc = "Harpoon: Go to previous file" })
--
-- vim.keymap.set("n", "<C-S-N>", function()
-- 	harpoon:list():next()
-- end, { desc = "Harpoon: Go to next file" })

--------------------------------
-- Misc Keymaps
--------------------------------
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
