local builtin = require("telescope.builtin")
local ignore_dirs = {
	".esbuild",
	".git",
	".idea",
	".serverless",
	"artifacts",
	"dist",
	"node_modules",
	".cache",
	".DS_Store",
	"**/.terraform", -- ignore all .terraform folders recursively
}
vim.keymap.set("n", "<leader>ff", function()
	local cmd = { "rg", "--files", "--hidden" }

	for _, dir in ipairs(ignore_dirs) do
		table.insert(cmd, "--glob")
		table.insert(cmd, "!" .. dir .. "/*")
	end

	builtin.find_files({
		hidden = true,
		no_ignore = true,
		find_command = cmd,
	})
end)
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>fs", function()
	local search_term = vim.fn.input("Grep > ")
	builtin.grep_string({
		search = search_term,
		initial_mode = "normal",
	})
end)
