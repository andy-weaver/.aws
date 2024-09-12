return {
	-- the colorscheme should be available when starting Neovim
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"python",
			"json",
			"yaml",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"sql",
			"bash",
			"rust",
			"dockerfile",
		},
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
			disable = {},
		},
	},

	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})
		end,
	},

	-- I have a separate config.mappings file where I require which-key.
	-- With lazy the plugin will be automatically loaded when it is required somewhere
	{ "folke/which-key.nvim", lazy = false },

	-- if some code requires a module from an unloaded plugin, it will be automatically loaded.
	-- So for api plugins like devicons, we can always set lazy=true
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{ "github/copilot.vim", lazy = false },

	{
		"folke/trouble.nvim",
		lazy = false,
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},

	{
		"wesleimp/stylua.nvim",
		lazy = false,
		cmd = { "StyluaFormat", "StyluaFormatWrite " },
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		lazy = false,
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>fmt",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS    ---@module "conform"  ---@type conform.setupOpts
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff", "black", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				rust = { "rust-analyzer", "rustfmt", stop_after_first = true },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				ignore = "^$",
				toggler = {
					line = "<leader>cc",
					block = "<leader>bc",
				},
			})
		end,
	},
}
