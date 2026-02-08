require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
		custom = {
			".esbuild",
			".git",
			".idea",
			".serverless",
			"artifacts",
			"dist",
			"*.iml",
			"node_modules",
			".cache",
			".DS_Store",
		},
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
})

vim.keymap.set("n", "<leader>fc", ":NvimTreeFindFile<CR>", { desc = "Find current file in browser" })
vim.api.nvim_set_keymap(
	"n",
	"<Leader>e",
	":NvimTreeToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle file explorer" }
)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvimTree",
	callback = function()
		-- Map Esc in normal mode to close the tree and run your command
		vim.api.nvim_buf_set_keymap(
			0,
			"n", -- normal mode
			"<Esc>", -- key
			"<C-w>l", -- replace with your command
			{ noremap = true, silent = true }
		)
	end,
})
