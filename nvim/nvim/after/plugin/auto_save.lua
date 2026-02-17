require("auto-save").setup({
	enabled = true,
	noautocmd = false,
	debounce_delay = 1500,
})

require("conform").setup({
	format_on_save = {
		-- These options will be passed to conform.format()
		-- timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		json = { "prettier" },
		yml = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
	},
	formatters = {
		eslint = {
			command = "npx",
			args = { "prettier", "-w", "$FILENAME" },
		},
	},
})
