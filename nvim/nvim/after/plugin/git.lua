require("gitsigns").setup({})

vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview Git Hunk" })
vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "Undo Hunk" })

-- Track if git diff is open
local git_diff_open = false

vim.keymap.set("n", "<leader>gd", function()
	if git_diff_open then
		-- Close diff
		vim.cmd("diffoff")
		vim.cmd("wincmd h")
		vim.cmd("close")
		git_diff_open = false
	else
		-- Open diff
		vim.cmd("Gvdiffsplit! HEAD")
		vim.cmd("wincmd l")
		git_diff_open = true
	end
end, { desc = "Toggle git diff split" })

-- DIFF related
vim.keymap.set("n", "<leader>do", function()
	vim.cmd("diffoff") -- turn off the diff
	vim.cmd("wincmd o") -- jump to the previous/other window
	git_diff_open = false
end, { desc = "Close git diff and keep only focused buffer" })
vim.keymap.set("n", "<leader>dg", ":diffget<CR>", { desc = "Get diff" })
vim.keymap.set("n", "<leader>dh", ":diffget //2<CR>", { desc = "Merge conflict: get diff from left window" })
vim.keymap.set("n", "<leader>dl", ":diffget //3<CR>", { desc = "Merge conflict: get diff from right window" })
