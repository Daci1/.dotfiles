vim.opt.guifont = "JetBrainsMono Nerd Font"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.laststatus = 3

-- Make undo persistent
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Make search case insensitive
vim.opt.ignorecase = true

-- netrw-specific mapping override (this is because it overwrites <C-l> by default when splitting)
local group = vim.api.nvim_create_augroup("FileTypeNetrw", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "netrw",
	callback = function()
		vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window", buffer = true, silent = true })
	end,
})

-- for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
