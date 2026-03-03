local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nickkadutskyi/jb.nvim" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{ "nvim-treesitter/nvim-treesitter-context" },
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" },
	{ "lewis6991/gitsigns.nvim" },
	{ "williamboman/mason.nvim" },
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		enabled = false,
	},
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-cmdline" },
	{ "rcarriga/cmp-dap" },
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go", -- requires GOPATH to be set correctly and also 'delve' installed
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"mxsdev/nvim-dap-vscode-js",
			-- {
			--     "microsoft/vscode-js-debug",
			--     build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
			--     version = "1.*",
			-- },
			{
				"microsoft/vscode-js-debug",
				version = "1.97.1",
				build = "npm i && npx gulp dapDebugServer",
			},
		},
	},
	{ "stevearc/dressing.nvim", opts = {} },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{ "zbirenbaum/copilot.lua" },
	{
		"klen/nvim-test",
		config = function()
			require("nvim-test").setup()
			require("nvim-test.runners.jest"):setup({
				-- command = "~/node_modules/.bin/jest",
				args = {
					"--config",
					"jest.unit.config.ts",
				},
				env = {
					NODE_OPTIONS = "--experimental-vm-modules",
				},
				-- file_pattern = "\\v(__tests__/.*|(spec|test))\\.(js|jsx|coffee|ts|tsx)$",
				-- find_files = { "{name}.test.{ext}", "{name}.spec.{ext}" },
				filename_modifier = nil,
				working_directory = nil,
			})
		end,
	},
	{ "igorlfs/nvim-dap-view", opts = {} },
	{ "stevearc/conform.nvim", opts = {} },
	{
		"okuuva/auto-save.nvim",
		version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
		cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			-- your config goes here
			-- or just leave it empty :)
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ "christopher-francisco/tmux-status.nvim", lazy = true, opts = {} },
	{ "nvim-lualine/lualine.nvim", opts = {} },
	{
		"folke/trouble.nvim",
		opts = {
			auto_preview = false,
			auto_close = true,
			focus = true,
			win = {
				type = "float",
			},
			keys = {
				["<esc>"] = "close",
				["<cr>"] = "jump_close",
			},
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
	},
	{ "petertriho/nvim-scrollbar" },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {},
	},
	{
		"nickjvandyke/opencode.nvim",
		dependencies = {
			{ "folke/snacks.nvim", optional = true, opts = { input = { enabled = true } } },
		},
		config = function()
			vim.g.opencode_opts = {
				port = 4080,
				provider = {
					enabled = "terminal",
					terminal = {},
				},
			}

			vim.o.autoread = true
			vim.keymap.set("n", "<leader>ot", function()
				require("opencode").toggle()
			end, { desc = "Toggle embedded" })

			vim.keymap.set("n", "<leader>oa", function()
				require("opencode").ask()
			end, { desc = "Ask opencode" })

			vim.keymap.set("v", "<leader>oa", function()
				require("opencode").ask("@this: ")
			end, { desc = "Ask opencode about selection" })

			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
		end,
	},
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local pids = vim.fn.systemlist("lsof -ti:4080")

		for _, pid in ipairs(pids) do
			pid = tonumber(pid)
			if pid then
				-- try graceful kill
				vim.loop.kill(pid, vim.loop.constants.SIGTERM)

				-- force kill fallback
				vim.defer_fn(function()
					pcall(vim.loop.kill, pid, vim.loop.constants.SIGKILL)
				end, 500)
			end
		end
	end,
})
