require("gitsigns").setup({})

vim.keymap.set('n', '<leader>gp', ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview Git Hunk" })
vim.keymap.set('n', '<leader>gu', ":Gitsigns reset_hunk<CR>", { desc = "Undo Hunk" })
