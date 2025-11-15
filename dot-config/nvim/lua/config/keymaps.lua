--------------------------------
-- Utilities Keymaps
--------------------------------
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file (normal mode)" })
vim.keymap.set("i", "<C-s>", "<ESC><cmd>w<CR>", { desc = "Save file (insert mode)" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Show diagnostics in floating window" })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format({
		lsp_format = "fallback",
	})
end, { desc = "Format current file with fallback" })

--------------------------------
-- Misc Keymaps
--------------------------------
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-space>", function()
	if _G.Snacks and _G.Snacks.terminal then
		_G.Snacks.terminal()
	else
		vim.cmd("stopinsert")
	end
end, { desc = "Exit terminal mode and move up" })
