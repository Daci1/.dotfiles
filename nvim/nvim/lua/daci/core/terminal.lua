vim.keymap.set("n", "<leader>lg", function()
	local addr = vim.v.servername

	-- Build tmux command
	local cmd = string.format("tmux new-window -e NVIM_LISTEN_ADDRESS=%s lazygit", addr)

	vim.fn.system(cmd)
end, { desc = "Open lazygit in new tmux window with NVIM_LISTEN_ADDRESS" })

vim.api.nvim_create_autocmd("TermClose", {
	pattern = "term://*lazygit*",
	callback = function()
		vim.schedule(function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
		end)
	end,
})

vim.g.toggle_term_buf = nil
vim.g.toggle_term_win = nil

vim.keymap.set({ "n", "t" }, "<C-t>", function()
	if vim.g.toggle_term_win and vim.api.nvim_win_is_valid(vim.g.toggle_term_win) then
		vim.api.nvim_win_close(vim.g.toggle_term_win, true)
		vim.g.toggle_term_win = nil
		return
	end

	if vim.g.toggle_term_buf and vim.api.nvim_buf_is_valid(vim.g.toggle_term_buf) then
		vim.cmd.vnew()
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(win, vim.g.toggle_term_buf)
		vim.cmd.wincmd("J") -- move to bottom
		vim.api.nvim_win_set_height(win, 15)
		vim.g.toggle_term_win = win
		vim.cmd.startinsert()
		vim.opt.number = false
		vim.opt.relativenumber = false
		return
	end

	-- Create new vertical terminal
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.startinsert()
	vim.cmd.wincmd("J") -- move to bottom
	vim.opt.number = false
	vim.opt.relativenumber = false
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_height(win, 15)

	-- Save window and buffer ID
	vim.g.toggle_term_win = win
	vim.g.toggle_term_buf = vim.api.nvim_win_get_buf(win)

	vim.api.nvim_buf_set_keymap(
		vim.g.toggle_term_buf,
		"t",
		"<Esc>",
		"<C-\\><C-n>",
		{ desc = "Only set <Esc> for this terminal buffer", noremap = true, silent = true }
	)
end, { desc = "Toggle bottom terminal with persistence", noremap = true, silent = true })
