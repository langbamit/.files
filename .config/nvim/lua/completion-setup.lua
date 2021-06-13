local npairs = require('nvim-autopairs')
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        ultisnips = true,
        treesitter = true
    }
}

local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
        -- elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() ==
        -- 1 then
        -- return t "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"
    elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
        -- elseif fn["UltiSnips#CanJumpBackwards"]() == 1 then
        -- return t "<C-R>=UltiSnips#JumpBackwards()<CR>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

vim.keymap.imap {"<Tab>", "v:lua.tab_complete()", expr = true}
vim.keymap.smap {"<Tab>", "v:lua.tab_complete()", expr = true}
vim.keymap.imap {"<S-Tab>", "v:lua.s_tab_complete()", expr = true}
vim.keymap.smap {"<S-Tab>", "v:lua.s_tab_complete()", expr = true}

npairs.setup {}

vim.g.user_emmet_install_global = 0
vim.g.user_emmet_install_command = 0
vim.g.user_emmet_mode = 'i'

vim.g.completion_confirm_key = ""
Mlem.completion_confirm = function()
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"](npairs.esc("<cr>"))
        else
            return npairs.esc("<cr>")
        end
    else
        return npairs.autopairs_cr()
    end
end

vim.keymap.inoremap {'<C-Space>', "compe#complete()", expr = true}
vim.keymap.inoremap {'<CR>', "v:lua.Mlem.completion_confirm()", expr = true}
vim.keymap.inoremap {'<C-e>', "compe#close('<C-e>')", expr = true}
vim.keymap.inoremap {'<C-f>', "compe#scroll({ 'delta': +4 })", expr = true}
vim.keymap.inoremap {'<C-d>', "compe#scroll({ 'delta': -4 })", expr = true}

vim.g.UltiSnipsExpandTrigger = "<C-j>"
-- g.UltiSnipsJumpForwardTrigger = "<C-j>"
-- g.UltiSnipsJumpBackwardTrigger = "<C-k>"

vim.keymap.nmap {"<Leader>V", "UltiSnipsEdit", silent = true}
