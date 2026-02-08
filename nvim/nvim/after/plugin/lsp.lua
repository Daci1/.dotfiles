local mason = require("mason")
-- local mason_lspconfig = require('mason-lspconfig')

mason.setup()
-- mason_lspconfig.setup({
--   ensure_installed = {
--     "ts_ls",
--     "bashls",
--     "gopls",
--   },
--   automatic_installation = true,
-- })

local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "gu", function()
		require("telescope.builtin").lsp_references({ initial_mode = "normal" })
	end, opts)

	vim.keymap.set("n", "gi", function()
		vim.lsp.buf.implementation()
	end, opts)

	vim.keymap.set("n", "gt", function()
		vim.lsp.buf.type_definition()
	end, opts)

	vim.keymap.set("n", "ga", function()
		vim.lsp.buf.code_action()
	end, opts)

	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.rename()
	end, opts)

	vim.keymap.set("n", "gf", function()
		vim.lsp.buf.format()
	end, opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("ts-server", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "json" },
	root_dir = vim.fs.root(0, { "tsconfig.json", "package.json", ".git" }),
	on_attach = on_attach,
	settings = {},
	capabilities = capabilities,
})

vim.lsp.config("jsonls", {
	cmd = { "npx", "vscode-json-languageserver", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_dir = vim.fs.root(0, { ".git", "tsconfig.json" }),
	on_attach = on_attach,
	settings = {
		json = {
			validate = { enable = true },
			schemas = {},
		},
	},
	capabilities = capabilities,
})

vim.lsp.config("terraform-ls", {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "tf" },
	root_dir = vim.fs.root(0, { ".git", ".terraform-version" }),
	on_attach = on_attach,
	settings = {},
	capabilities = capabilities,
})

vim.lsp.enable({ "ts-server", "jsonls", "terraform-ls" })
