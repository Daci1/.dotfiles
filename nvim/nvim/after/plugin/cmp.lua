local cmp = require("cmp")

cmp.setup({
	enabled = true,
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}),
})

cmp.setup.filetype({ "dap-repl" }, {
	sources = {
		{ name = "dap" },
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline({
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

		-- Confirm with Tab
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true }) -- true to select the currently highlighted item
			else
				fallback() -- default Tab behavior if cmp menu is not visible
			end
		end, { "i", "c" }),
	}),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})
