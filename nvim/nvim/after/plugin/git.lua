require("gitsigns").setup({})

vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview Git Hunk" })
vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "Undo Hunk" })
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit HEAD | wincmd l<CR>", { desc = "Open git diff split" })
vim.keymap.set("n", "<leader>gc", ":Gvdiffsplit! | wincmd l<CR>", { desc = "Open git diff 3 way split" })

-- DIFF related
vim.keymap.set("n", "<leader>do", function()
	vim.cmd("diffoff") -- turn off the diff
	vim.cmd("wincmd o") -- jump to the previous/other window
end, { desc = "Close git diff and keep only focused buffer" })
vim.keymap.set("n", "<leader>dg", ":diffget<CR>", { desc = "Get diff" })
vim.keymap.set("n", "<leader>dh", ":diffget //2<CR>", { desc = "Merge conflict: get diff from left window" })
vim.keymap.set("n", "<leader>dl", ":diffget //3<CR>", { desc = "Merge conflict: get diff from right window" })
