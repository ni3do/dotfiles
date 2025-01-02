require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "ZZ", "<cmd> qa <CR>", { desc = "GENERAL Quit nvim" })

nomap("n", "<tab>")
