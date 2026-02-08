vim.g.mapleader = " "

-- Copy/Paste from the clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true })

-- Move half screen up/down always stays in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- THIS IS SO GREAT: move all selected up or down in visual
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Navigate windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Open files under cursor with gx
vim.keymap.set("n", "gx", function()
	local file = vim.fn.expand("<cfile>")

	if vim.fn.filereadable(file) == 1 then
		vim.cmd("edit " .. file)
	else
		-- fall back to default gx behavior (URLs etc)
		vim.ui.open(file)
	end
end, { noremap = true, silent = true })
