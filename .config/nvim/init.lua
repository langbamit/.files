
local vim = vim
local cmd, opt, g, fn = vim.cmd, vim.opt, vim.g, vim.fn

local keymap = require("keymap")
require('globals-setup')

-- cmd 'source ~/.vimrc'
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
-- FIX: Change todo
-- WARN: hahahaah
-- NOTE: sdsds
-- TODO: test todo
function _G.with_cmd(rhs) return '<cmd>' .. rhs .. '<cr>' end

-- LuaFormatter off
vim.tbl_map(require('paq-nvim').paq, {
    'savq/paq-nvim'; -- Manager itself to avoid clean
    {'dracula/vim', as = 'dracula'};

    --- Basic
    'nvim-lua/plenary.nvim';
    'norcalli/nvim-colorizer.lua';
    'tpope/vim-repeat';
    'tpope/vim-surround';
    'terrortylor/nvim-comment',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'kyazdani42/nvim-web-devicons';
    'folke/todo-comments.nvim';
    'windwp/nvim-spectre';
    'glepnir/dashboard-nvim';
    'ahmedkhalf/lsp-rooter.nvim';
    'mg979/vim-visual-multi';
    --- Git
    'lewis6991/gitsigns.nvim';

    --- Tree-sitter
    {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd 'TSUpdate' end};
    'nvim-treesitter/nvim-treesitter-textobjects';
    'nvim-treesitter/playground';
    'RRethy/nvim-treesitter-textsubjects';
    --- Buffer Tabs
        --- Use ranger as floating window
    'kevinhwang91/rnvimr';
        --- LSP & language support
    'neovim/nvim-lspconfig';
    'onsails/lspkind-nvim';
    'kosayoda/nvim-lightbulb';
    'ray-x/lsp_signature.nvim';
    'RRethy/vim-illuminate';
    'RishabhRD/popfix';
    'RishabhRD/nvim-lsputils';
    'simrat39/rust-tools.nvim';


    --- Autocomplete
    'hrsh7th/nvim-compe';
    'windwp/nvim-autopairs';
    'mattn/emmet-vim';

    --- Snippets
    'hrsh7th/vim-vsnip';
    'rsh7th/vim-vsnip-integ';

    --- Telescope
    'nvim-lua/popup.nvim';
    'nvim-telescope/telescope.nvim';
    'nvim-telescope/telescope-media-files.nvim';
    'nvim-telescope/telescope-project.nvim';
    {'nvim-telescope/telescope-fzy-native.nvim', run='git submodule update --init --recursive'};
    -- 'fhill2/telescope-ultisnips.nvim';

    --- Misc
    'hoob3rt/lualine.nvim';
    'akinsho/nvim-bufferline.lua';
    'mbbill/undotree';
    -- 'Yggdroot/indentLine';
    {'lukas-reineke/indent-blankline.nvim', branch = 'lua'};
    'numToStr/Navigator.nvim';
    'folke/which-key.nvim';
})
-- LuaFormatter on


do --- General
    

    require('general-setup')
    -- Dashboard
    g.dashboard_default_executive = 'telescope'
    g.dashboard_session_directory = Mlem.paths.session
    g.dashboard_custom_header = Mlem.banner
    g.dashboard_custom_footer = {'', '', '', '', '', '', '', 'https://github.com/langbamit'}
    cmd [[ autocmd FileType dashboard set showtabline=0 laststatus=0 | autocmd BufLeave <buffer> set showtabline=2 laststatus=2 ]]
    vim.g.dashboard_custom_section = {
        a = {description = {'  Find File          '}, command = 'Telescope find_files'},
        b = {description = {'  Recently Used Files'}, command = 'Telescope oldfiles'},
        c = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
        d = {description = {'  Find Word          '}, command = 'Telescope live_grep'},
        -- e = {description = {'  Settings           '}, command = ':e '..CONFIG_PATH..'/lv-settings.lua'}
    }
    g.indent_blankline_filetype_exclude = { 'dashboard' }

    g.rnvimr_enable_ex = 1
    g.rnvimr_enable_bw = 1

    keymap.nnoremap {'<M-o>', with_cmd 'RnvimrToggle', silent = true}

    local lualine = {
    location = function()
        return '(Ln %l/%L, Col %c)'
    end
    }

    require('lualine').setup {
    options = {theme = 'dracula', section_separators = '', component_separators = ''},
    sections = {
        lualine_b = {'branch', 'b:gitsigns_status' },
        lualine_c = {'filename', lualine.location },
        lualine_x = {require('spectre.state_utils').status_line, 'encoding','fileformat', 'filetype'},
        lualine_y = {},
        lualine_z = {},
    }
    }

    keymap.nnoremap {'<M-u>', with_cmd "UndotreeToggle"}

    require('colorizer').setup({

    })

    require('spectre').setup {}

    keymap.nnoremap { "<leader>sr", with_cmd "lua require('spectre').open()" }

    -- search current word
    -- keymap.nnoremap { "<leader>srw", "viw:lua require('spectre').open_visual()<CR>" }
    -- keymap.vnoremap { "<leader>s", with_cmd "lua require('spectre').open_visual()" }

    -- search in current file
    -- keymap.nnoremap  <leader>sp viw:lua require('spectre').open_file_search()<cr>

    require('nvim_comment').setup {
    -- line_mapping = " cl",
    -- operator_mapping = " c"
    }

    require'todo-comments'.setup{
    highlight = {
        keyword = "bg"
    },
    colors = {
        error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#ff5555" },
        warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#ffb86c"},
        info = { "LspDiagnosticsDefaultInformation", "#8be9fd" },
        hint = { "LspDiagnosticsDefaultHint", "#50fa7b" },
        default = { "Identifier", "#bd93f9" },
    },
    }

    keymap.nnoremap {'<C-h>', '<C-w>h'}
    keymap.nnoremap {'<C-j>', '<C-w>j'}
    keymap.nnoremap {'<C-k>', '<C-w>k'}
    keymap.nnoremap {'<C-l>', '<C-w>l'}

    keymap.nnoremap {'<Tab>', ':bnext<CR>'}
    keymap.nnoremap {'<S-Tab>', ':bprevious<CR>'}

    keymap.inoremap {'jk', '<esc>'}
    keymap.inoremap {'kj', '<esc>'}

    keymap.nnoremap {'<esc>', ':noh<return><esc>', silent = true}

    g.mapleader = ' '
    keymap.nnoremap{' ', ''}
    keymap.xnoremap{' ', ''}

    keymap.vnoremap { '<', '<gv'}
    keymap.vnoremap { '>', '>gv'}

    require('Navigator').setup()
    keymap.nnoremap { '<m-h>', with_cmd "lua require('Navigator').left()", silent = true}
    keymap.nnoremap { '<m-j>', with_cmd "lua require('Navigator').down()", silent = true}
    keymap.nnoremap { '<m-k>', with_cmd "lua require('Navigator').up()", silent = true}
    keymap.nnoremap { '<m-l>', with_cmd "lua require('Navigator').right()", silent = true}

    g.indent_blankline_char = '┊'
end
require('smartquit')
require('treesitter-setup')
require('lsp-setup')
require('completion-setup')
require('telescope-setup')



-- colors for active , inactive buffer tabs
require"bufferline".setup {
    options = {
    separator_style = {'', ''},
    tab_size = 22,
    enforce_regular_tabs = true,
    view = "multiwindow",
    show_buffer_close_icons = true
    }
}




require('gitsigns').setup()
