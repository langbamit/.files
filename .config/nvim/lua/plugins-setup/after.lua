local vim = vim
local g, cmd, keymap = vim.g, vim.cmd, vim.keymap

vim.cmd 'colorscheme dracula'

-- Dashboard
keymap.nnoremap {'<leader>ss', with_cmd 'SessionSave'}
keymap.nnoremap {'<leader>sl', with_cmd 'SessionLoad'}
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

-- g.rnvimr_enable_ex = 1
-- g.rnvimr_enable_bw = 1
keymap.nnoremap {'<M-o>', with_cmd 'RnvimrToggle', silent = true}

local lualine = {
location = function()
    return '(Ln %l/%L, Col %c)'
end
}

require('lualine').setup {
    options = {theme = 'dracula', section_separators = '', component_separators = ''},
    sections = {
        lualine_b = {'branch', 'b:gitsigns_status', 'b:gitblame_status' },
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
keymap.nnoremap {'<C-h>', '<C-w>h'}
keymap.nnoremap {'<C-j>', '<C-w>j'}
keymap.nnoremap {'<C-k>', '<C-w>k'}
keymap.nnoremap {'<C-l>', '<C-w>l'}

keymap.nnoremap {'<Tab>', ':bnext<CR>'}
keymap.nnoremap {'<S-Tab>', ':bprevious<CR>'}

keymap.inoremap {'jk', '<esc>'}
keymap.inoremap {'kj', '<esc>'}

keymap.nnoremap {'<esc>', ':noh<return><esc>', silent = true}


keymap.vnoremap { '<', '<gv'}
keymap.vnoremap { '>', '>gv'}
-- Nvim Tree
keymap.nnoremap {'<leader>e', with_cmd "NvimTreeToggle", silent=true}

require('Navigator').setup()
keymap.nnoremap { '<m-h>', with_cmd "lua require('Navigator').left()", silent = true}
keymap.nnoremap { '<m-j>', with_cmd "lua require('Navigator').down()", silent = true}
keymap.nnoremap { '<m-k>', with_cmd "lua require('Navigator').up()", silent = true}
keymap.nnoremap { '<m-l>', with_cmd "lua require('Navigator').right()", silent = true}

g.indent_blankline_char = '┊'
keymap.nnoremap {'<leader>t', with_cmd "lua require('spectre').open()", silent=true }
