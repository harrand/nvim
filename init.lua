require("custom.globals")

local options = {
	completeopt = { "menuone", "noselect" }, -- options for insert mode completion (for cmp plugin)
	conceallevel = 0, -- so that `` is visible in markdown files
	cmdheight = 2, -- number of of screen lines to use for the command line
	swapfile = false,
	hlsearch = true, -- highlight all matches of previous search pattern
	incsearch = true, -- highlight matches of current search pattern as it is typed
	scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor.
	-- smarttab = true,
	undofile = true, -- keep undo history between sessions
	backup = false, -- Some servers have issues with backup files, see #649.
	writebackup = false,
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

-- highlight yank
vim.cmd([[
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 80})
augroup END
]])

-- wrap git commit body message lines at 72 characters
vim.cmd([["
    augroup gitsetup
        autocmd!
        autocmd FileType gitcommit
                \ autocmd CursorMoved,CursorMovedI * 
                        \ let &l:textwidth = line('.') == 1 ? 50 : 72
augroup end
"]])

vim.cmd([["
let $PROJ = "C:/Projects"
let $GLOBCFG = $LOCALAPPDATA .. "\\nvim"
let $CFG = $GLOBCFG .. "\\lua\\custom"
cd $PROJ

set tabstop=4
set shiftwidth=4
set cindent
filetype plugin indent on

]])

local function open_nvim_tree(data)
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


local enable_providers = {
	"python3_provider",
	-- and so on
}

for _, plugin in pairs(enable_providers) do
	vim.g["loaded_" .. plugin] = nil
	vim.cmd("runtime " .. plugin)
end
