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
		["<S-CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = false })
			else
				fallback() -- Fall back to normal <S-CR> behavior if cmp is not visible
			end
		end, { "i", "c" }), -- Ensure this works in both insert and cmdline modes
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
