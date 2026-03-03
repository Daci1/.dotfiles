require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 500,
	},
})

vim.keymap.set("i", "<Tab>", function()
	local copilot = require("copilot.suggestion")
	if copilot.is_visible() then
		return copilot.accept()
	else
		return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
	end
end, { expr = true, noremap = true })

-- Dismiss copilot suggestions when typing
vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		require("copilot.suggestion").dismiss()
	end,
})

