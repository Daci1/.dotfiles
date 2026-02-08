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

require("avante_lib").load()
require("avante").setup({
	provider = "copilot",
	mode = "agentic",
})

-- User command to reset local state of avante
-- useful when apply code doesn't work
local function avante_reset()
	local path = vim.fn.expand("~/.local/state/nvim/avante")
	if vim.fn.isdirectory(path) == 1 then
		vim.fn.delete(path, "rf") -- "rf" = recursive + force
		print("Avante directory reset!")
	else
		print("Avante directory does not exist.")
	end
end

-- Create a custom command that calls this function
vim.api.nvim_create_user_command("AvanteReset", avante_reset, {})
