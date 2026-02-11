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

	vim.keymap.set("n", "gD", ":Trouble diagnostics<CR>", opts)

	vim.keymap.set("n", "gu", ":Trouble lsp_references<CR>", opts)

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

vim.lsp.config("eslint", {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
		"svelte",
		"astro",
		"htmlangular",
	},
	workspace_required = true,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", function()
			client:request_sync("workspace/executeCommand", {
				command = "eslint.applyAllFixes",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = lsp.util.buf_versions[bufnr],
					},
				},
			}, nil, bufnr)
		end, {})
		on_attach()
	end,
	root_dir = vim.fs.root(0, { "tsconfig.json", "package.json", ".git" }),
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

vim.lsp.enable({
	"ts-server",
	"eslint",
	"jsonls",
	"terraform-ls",
})
