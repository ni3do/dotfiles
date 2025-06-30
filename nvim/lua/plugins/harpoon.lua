return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local status_ok, harpoon = pcall(require, "harpoon")
		if not status_ok then
			return
		end
		harpoon:setup()

		-- picker
		local function generate_harpoon_picker()
			local file_paths = {}
			for _, item in ipairs(harpoon:list().items) do
				table.insert(file_paths, {
					text = item.value,
					file = item.value,
				})
			end
			return file_paths
		end
		--------------------------------
		-- Harpoon Keymaps
		--------------------------------
		vim.keymap.set("n", "<leader>fh", function()
			Snacks.picker.files({
				finder = generate_harpoon_picker,
			})
		end, { desc = "Open Harpoon picker" })

		vim.keymap.set("n", "<leader>m", function()
			harpoon:list():add()
		end, { desc = "Add file to Harpoon list" })

		vim.keymap.set("n", "<C-e>", function()
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

		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Go to previous file" })

		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Go to next file" })
	end,
}
