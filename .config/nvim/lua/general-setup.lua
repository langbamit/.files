local vim = vim
local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.laststatus = 2
opt.inccommand = 'nosplit'
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.updatetime = 300
opt.iskeyword:append('-')
opt.hidden = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smarttab = true
opt.expandtab = true
opt.lazyredraw = true
opt.mouse = 'a'
opt.cmdheight = 2
opt.splitbelow = true
opt.splitright = true
opt.wrap = true
opt.scrolloff = 5
opt.sidescroll = 5
opt.whichwrap = '[,]'
opt.showmode = false
opt.showmatch = true
opt.matchtime = 5
opt.completeopt = {'menuone', 'noinsert', 'noselect'}
opt.shortmess:append('cI')
opt.hlsearch = true
opt.pumblend = 10
-- opt.signcolumn = 'number'
opt.showtabline = 2
opt.timeoutlen = 500
opt.ttimeoutlen = -1
opt.sessionoptions:remove('folds')
opt.sessionoptions:append('globals')
opt.showbreak = ' ↳  '
opt.listchars = 'tab:→ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨'

opt.undofile = true
opt.undodir = Mlem.paths.undo

opt.termguicolors = true

vim.g.mapleader = ' '
vim.keymap.nnoremap{' ', ''}
vim.keymap.xnoremap{' ', ''}

vim.keymap.nnoremap {'<C-h>', '<C-w>h'}
vim.keymap.nnoremap {'<C-j>', '<C-w>j'}
vim.keymap.nnoremap {'<C-k>', '<C-w>k'}
vim.keymap.nnoremap {'<C-l>', '<C-w>l'}

vim.keymap.nnoremap {'<Tab>', ':bnext<CR>'}
vim.keymap.nnoremap {'<S-Tab>', ':bprevious<CR>'}

vim.keymap.inoremap {'jk', '<esc>'}
vim.keymap.inoremap {'kj', '<esc>'}

vim.keymap.nnoremap {'<esc>', ':noh<return><esc>', silent = true}


vim.keymap.vnoremap { '<', '<gv'}
vim.keymap.vnoremap { '>', '>gv'}
-- start terminal in insert mode
vim.cmd [[ au BufEnter * if &buftype == 'terminal' | :startinsert | endif ]]