require("lualine").setup({
	sections = {
		lualine_c = {
			{
				function()
					return require("tmux-status").tmux_windows()
				end,
				cond = function()
					return require("tmux-status").show()
				end,
				padding = { left = 3 },
			},
		},
	},
})
