local vim = vim
local cmd, opt, g = vim.cmd, vim.opt, vim.g

cmd 'source ~/.vimrc'

local function map(lhs, rhs, mode, expr)    -- wait for lua keymaps: neovim/neovim#13823
    mode = mode or 'n'
    if mode == 'n' then rhs = '<cmd>' .. rhs .. '<cr>' end
    vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap=true, silent=true, expr=expr})
end

vim.tbl_map(require('paq-nvim').paq, {
    {'dracula/vim', as='dracula' };

    --- Tree-sitter
    {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd 'TSUpdate' end};
    'nvim-treesitter/nvim-treesitter-textobjects';
    'nvim-treesitter/playground';

    --- Buffer Tabs
	'akinsho/nvim-bufferline.lua';
	--- dev-icons
    'kyazdani42/nvim-web-devicons';

	--- Comment stuff out
    'tpope/vim-commentary';

    --- LSP & language support
    'neovim/nvim-lspconfig';
    'hrsh7th/nvim-compe';

    --- Telescope
    'nvim-lua/popup.nvim';
	'nvim-lua/plenary.nvim';
	'nvim-telescope/telescope.nvim';
	'nvim-telescope/telescope-media-files.nvim';
})

do ---- Appearance
    opt.termguicolors = true
    cmd 'colorscheme dracula'
    --require 'lush' (require 'melange') --dev

    opt.statusline = table.concat({
        '%2{mode()} | ',
        'f',            -- relative path
        'm',            -- modified flag
        'r',
        '=',
        'y',            -- filetype
        '8(%l,%c%)',    -- line, column
        '8p%% ',        -- file percentage
    }, ' %')
end



require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}
-- nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
-- nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
-- nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
-- nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
-- nnoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.hover()<CR>
-- nnoremap <silent> gE <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
-- nnoremap <silent> ge <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

-- nnoremap <silent> <Leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
-- nnoremap <silent> <Leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

-- " auto-format
-- autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 100)

-- inoremap <silent><expr> <C-Space> compe#complete()
-- inoremap <silent><expr> <CR>      compe#confirm('<CR>')
-- inoremap <silent><expr> <C-e>     compe#close('<C-e>')
-- inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
-- inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

-- " Use <Tab> and <S-Tab> to navigate through popup menu
-- inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

-- " Set completeopt to have a better completion experience
-- set completeopt=menuone,noinsert,noselect

-- " Avoid showing message extra message when using completion
-- set shortmess+=c
do
    local conf = require('lspconfig')
    conf.rust_analyzer.setup{}

    --- GOTO Mappings
    map('gd', 'lua vim.lsp.buf.definition()')
    map('gD', 'lua vim.lsp.buf.declaration()')
    map('gr', 'lua vim.lsp.buf.references()')
    map('gs', 'lua vim.lsp.buf.document_symbol()')
    map('ga', 'lua vim.lsp.buf.code_action()')

    --- diagnostics navegation mappings
    map('gE', 'lua vim.lsp.diagnostic.goto_prev()')
    map('ge', 'lua vim.lsp.diagnostic.goto_next()')

    --- Use <Tab> and <S-Tab> to navigate through popup menu
    map('<Tab>',   "pumvisible() ? '<C-n>' : '<Tab>'", 'i', true)
    map('<S-Tab>', "pumvisible() ? '<C-p>' : '<S-Tab>'", 'i', true)

    --- auto-commands
    cmd "au BufWritePre *.rs lua vim.lsp.buf.formatting_sync()"
    cmd "au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()"

end


do ---- Telescope
    local telescope = require('telescope');
    local actions = require('telescope.actions')
    telescope.setup {
        defaults = {
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_better,
                    ["<C-k>"] = actions.move_selection_worse,
                    ["<C-q>"] = actions.send_to_qflist,
                    ["<Esc>"] = actions.close
                },
            },
        },
        extensions = {
            media_files = {
                file_types = {"png", "jpg", "mp4", "webm", "pdf"},
                find_cmd = "rg"
            }
        }
    }
    telescope.load_extension('media_files')
    map('<leader>ff', 'Telescope find_files')
    map('<leader>fg', 'Telescope live_grep')
    map('<leader>fb', 'Telescope buffers')
    map('<leader>fh', 'Telescope help_tags')
end


-- colors for active , inactive buffer tabs
require "bufferline".setup {
    options = {
        separator_style = {'', ''},
        tab_size = 22,
        enforce_regular_tabs = true,
        view = "multiwindow",
        show_buffer_close_icons = true,
    },
}

do -- commentary
    map('<leader>/', 'Commentary')
    -- map('<leader>/', 'Commentary', 'v')
    cmd 'vnoremap <leader>/ :Commentary<CR>'
end