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
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"catppuccin/nvim", name = "catppuccin", priority = 1000 
	},
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
		'williamboman/mason.nvim'
	},
	{
		'williamboman/mason-lspconfig.nvim'
	},
	{
		'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'
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
	{
		'L3MON4D3/LuaSnip'
	},
	{ 'numToStr/Comment.nvim', opts = {} },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go", -- requires GOPATH to be set correctly and also 'delve' installed
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
		}
	},
    {
        'stevearc/dressing.nvim',
        opts = {},
    }
})
