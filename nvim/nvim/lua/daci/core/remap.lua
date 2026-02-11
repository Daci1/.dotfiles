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
	-- Grab the entire WORD under cursor, including colons
	local cword = vim.fn.expand("<cWORD>")

	-- Strip surrounding parentheses, e.g. (file:line:col)
	local cfile = cword:match("^%((.*)%)$") or cword

	-- Try to extract file:line:col
	local file, line, col = cfile:match("([^:]+):(%d+):?(%d*)")

	-- Prefer parsed file if it exists, otherwise raw cfile
	local target = file or cfile

	if vim.fn.filereadable(target) == 1 then
		-- Find leftmost window that is NOT nvim-tree
		local target_win = nil
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype ~= "NvimTree" then
				target_win = win
				break
			end
		end

		-- If we found a suitable window, switch to it
		if target_win then
			vim.api.nvim_set_current_win(target_win)
		end

		-- Open file
		vim.cmd("edit " .. target)

		-- If we had a line number, jump to it
		if line then
			vim.cmd(line)

			-- Optional column jump
			if col and col ~= "" then
				vim.cmd("normal! " .. col .. "|")
			end
		end
	else
		vim.ui.open(cfile)
	end
end, { noremap = true, silent = true })
