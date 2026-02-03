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
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
    { "nickkadutskyi/jb.nvim" },
	{
		"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"
	},
	{
		"mbbill/undotree"
	},
	{
		"tpope/vim-fugitive"
	},
	{
		"lewis6991/gitsigns.nvim"
	},
	{
		'williamboman/mason.nvim'
	},
	{
		'williamboman/mason-lspconfig.nvim'
	},
	{
		'VonHeikemen/lsp-zero.nvim', branch = 'v3.x', enabled = false,
	},
	{
		'neovim/nvim-lspconfig'
	},
	{
		'hrsh7th/cmp-nvim-lsp'
	},
	{
		'hrsh7th/nvim-cmp'
	},
	{ 'numToStr/Comment.nvim', opts = {} },
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
                build = "npm i && npx gulp dapDebugServer"
            }
		}
	},
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "yetone/avante.nvim",
        build = "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },
    {
        "klen/nvim-test",
        config = function()
            require("nvim-test").setup()
            require('nvim-test.runners.jest'):setup {
                -- command = "~/node_modules/.bin/jest",
                args = {
                    "--config", "jest.unit.config.ts",
                },
                env = {
                    NODE_OPTIONS = "--experimental-vm-modules",
                },
                -- file_pattern = "\\v(__tests__/.*|(spec|test))\\.(js|jsx|coffee|ts|tsx)$",
                -- find_files = { "{name}.test.{ext}", "{name}.spec.{ext}" },
                filename_modifier = nil,
                working_directory = nil,
            }
        end,
    }
})
