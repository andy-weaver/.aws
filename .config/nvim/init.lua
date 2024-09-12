-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- stop looking for perl or ruby
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- load the .vimrc file
vim.cmd("source $HOME/.vimrc")

-- set xclip as the clipboard provider
vim.opt.clipboard = "unnamedplus"

-- load the plugins
require("config.lazy")
require("lazy").setup("plugins")

-- remap the leader key
vim.g.mapleader = " "

-- custom keymaps
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-x>", ":wq<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>term", ":terminal<CR>i", { noremap = true, silent = true })

-- custom commands

-- Format the current buffer
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.api.nvim_set_keymap("n", "<leader>fmt", ":Format<CR>", { noremap = true, silent = true })

-- maps for nvim-tree
vim.api.nvim_set_keymap("n", "<leader>tree", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ft", ":NvimTreeFocus<CR>", { noremap = true, silent = true })

-- next window
vim.api.nvim_set_keymap("n", "<leader>ww", "<C-w>h", { noremap = true, silent = true })

-- git commands
vim.api.nvim_set_keymap("n", "<leader>gs", "!git status<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ga", "!git add .<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gc", "!git commit -m 'changes lol'<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gp", "!git push<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>gx",
	":!git add . && git commit -m 'changes lol' && git push<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>gl", "!git pull<CR>", { noremap = true, silent = true })

-- open a terminal in the current buffer
-- vim.api.nvim_set_keymap("n", "<leader>tt", ":botright 15split | term<CR>i", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tt", ":lua ToggleTerminal()<CR>", { noremap = true, silent = true })

function ToggleTerminal()
	local found_terminal = false
	if vim.api.nvim_get_mode().mode == "t" then
		vim.cmd("<C-\\><C-n>")
		vim.cmd("<C-w>q")
	end

	while not found_terminal do
		-- check if there is already a terminal open
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
				vim.api.nvim_set_current_win(win)
				found_terminal = true
			end
		end

		-- if not found, open a terminal
		if not found_terminal then
			vim.cmd("botright 15split | term") -- open a terminal in the current buffer
		end
	end

	vim.cmd(":set modifiable") -- make the terminal buffer modifiable
	vim.cmd("startinsert") -- go to insert mode
end

-- while in terminal mode, press <ESC> to hide the terminal and go back to normal mode
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n><C-w>q<C-w>l", { noremap = true, silent = true })

-- while in terminal mode, press <C-/><C-/> to exit terminal mode but stay in the terminal buffer
vim.api.nvim_set_keymap("t", "<C-/><C-/>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<TAB>", ":lua TabWhileInTerminal()<CR>", { noremap = true, silent = true })

function TabWhileInTerminal()
	-- if in insert mode, go to normal mode and then switch to the visible window on the right
	if vim.api.nvim_get_mode().mode == "i" then
		vim.cmd("<C-\\><C-n>")
		vim.cmd("<C-w>k<C-w>l")

	-- if in terminal mode,
	elseif vim.api.nvim_get_mode().mode == "t" then
		vim.cmd("<C-\\><C-n><C-w>k<C-w>l")

	-- if in normal mode, switch to the visible window on the right
	else
		vim.cmd("<C-w>k<C-w>l")
	end
end

-- Function to open the file tree if no arguments are passed to Neovim
function OpenTreeIfNoArgs()
	print(vim.fn.argc())
	if vim.fn.argc() == 0 then
		vim.cmd("NvimTreeToggle")
	end
end

-- Call the function when Vim enters
vim.api.nvim_create_autocmd("VimEnter", { callback = OpenTreeIfNoArgs })

vim.api.nvim_set_keymap(
	"n",
	"<leader>q",
	":lua HandleLeaderQForDifferentReadonlyState()<CR>",
	{ noremap = true, silent = true }
)
function HandleLeaderQForDifferentReadonlyState()
	if vim.bo.readonly then
		vim.cmd(":q!")
	elseif vim.bo.modifiable then
		vim.cmd(":wq")
	elseif vim.bo.modifiable == false then
		vim.cmd(":q!")
	else
		vim.cmd(":q")
	end
end
