local lsp_zero = require('lsp-zero')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local cmp = require('cmp')

lsp_zero.preset("recommended")


mason.setup({})
mason_lspconfig.setup({
	ensure_installed = {
		'tsserver',
		"bashls",
		"gopls",
	},
	handlers = {
		lsp_zero.default_setup,
	}
})

lsp_zero.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "gu", function() require('telescope.builtin').lsp_references({ initial_mode = 'normal'}) end, opts)
	vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
	vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
	vim.keymap.set("n", "ga", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("v", "ga", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "gr", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "gf", function() vim.lsp.buf.format() end, opts)
end)

cmp.setup({
	preselect = 'item',
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({select = false}),
	}),
})

lsp_zero.setup()
