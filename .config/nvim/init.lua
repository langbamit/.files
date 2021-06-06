local vim = vim
local cmd, opt, g, fn = vim.cmd, vim.opt, vim.g, vim.fn

cmd 'source ~/.vimrc'

mlem = {}

local function map(lhs, rhs, mode)
    mode = mode or 'n'
    if mode == 'n' then rhs = '<cmd>' .. rhs .. '<cr>' end
    vim.api.nvim_set_keymap(mode, lhs, rhs, {silent = true})
end

local function noremap(lhs, rhs, mode, expr) -- wait for lua keymaps: neovim/neovim#13823
    mode = mode or 'n'
    if mode == 'n' then rhs = '<cmd>' .. rhs .. '<cr>' end
    vim.api.nvim_set_keymap(mode, lhs, rhs,
                            {noremap = true, silent = true, expr = expr})
end

-- LuaFormatter off
vim.tbl_map(require('paq-nvim').paq, {
    'savq/paq-nvim'; -- Manager itself to avoid clean
    {'dracula/vim', as = 'dracula'};

    --- Basic
    'tpope/vim-repeat';
    'tpope/vim-surround';
    'tpope/vim-commentary',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'kyazdani42/nvim-web-devicons';

    --- Git
    'lewis6991/gitsigns.nvim';

    --- Tree-sitter
    {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd 'TSUpdate' end};
    'nvim-treesitter/nvim-treesitter-textobjects';
    'nvim-treesitter/playground';

    --- Buffer Tabs
    'akinsho/nvim-bufferline.lua';
     --- Use ranger as floating window
    'kevinhwang91/rnvimr';
     --- LSP & language support
    'neovim/nvim-lspconfig';
    'onsails/lspkind-nvim';
    'kosayoda/nvim-lightbulb';
    'ray-x/lsp_signature.nvim';
    'RishabhRD/popfix';
	'RishabhRD/nvim-lsputils';
    'simrat39/rust-tools.nvim';


    --- Autocomplete
    'hrsh7th/nvim-compe';
    'windwp/nvim-autopairs';

    --- Snippets
    'SirVer/ultisnips';

    --- Telescope
    'nvim-lua/popup.nvim';
    'nvim-lua/plenary.nvim';
    'nvim-telescope/telescope.nvim';
    'nvim-telescope/telescope-media-files.nvim';
    'nvim-telescope/telescope-project.nvim';
    'fhill2/telescope-ultisnips.nvim';
    -- 'nvim-telescope/telescope-fzy-native.nvim';
    -- 'fhill2/telescope-ultisnips.nvim';

    --- Misc
    'hoob3rt/lualine.nvim';
    -- 'Yggdroot/indentLine';
	{'lukas-reineke/indent-blankline.nvim', branch = 'lua'};
    -- 'folke/which-key.nvim'
})
-- LuaFormatter on

do --- General
   opt.laststatus = 2

   g.indent_blankline_char = '┊'
end

do ---- Appearance
    opt.termguicolors = true
    cmd 'colorscheme dracula'

    require('lualine').setup {
        options = {
            theme = 'dracula',
            section_separators = '',
            component_separators = ''
        },
        sections = {
            lualine_b = {'branch', 'b:gitsigns_status'}
        }
    }
end

do
    local npairs = require('nvim-autopairs')

    npairs.setup()

    -- g.completion_confirm_key = ""
    -- mlem.completion_confirm = function()
    --     if vim.fn.pumvisible() ~= 0 then
    --         if vim.fn.complete_info()["selected"] ~= -1 then
    --             return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    --         else
    --             return npairs.esc("<cr>")
    --         end
    --     else
    --         return npairs.autopairs_cr()
    --     end
    -- end

    -- noremap('<CR>', '<cmd>lua mlem.completion_confirm()<CR>', 'i')
end
require('nvim-treesitter.configs').setup {
    context_commentstring = {enable = true},
    autopairs = {enable = true},
    autotag = {enable = true},
    nvim_lsp = {enable = true},
    ultisnips = {enable = true},
    highlight = {enable = true, additional_vim_regex_highlighting = true}
}

do -- LSP & Autocomplete
    local lsp = require('lspconfig')

    local on_attach = function(client, bufnr)
        local buf_map = function(rhs, lhs, mode, expr)
            mode = mode or 'n'
            if mode == 'n' then rhs = '<cmd>' .. rhs .. '<cr>' end
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, {
                noremap = true,
                silent = true,
                expr = expr
            })
        end

        -- SignatureHelp
        require('lsp_signature').on_attach {
            bind = true,
            hint_prefix = "",
            handler_opts = {border = "single"}
        }

        --- GOTO Mappings
        buf_map('gd', 'lua vim.lsp.buf.definition()')
        buf_map('gD', 'lua vim.lsp.buf.declaration()')
        buf_map('gr', 'lua vim.lsp.buf.references()')
        buf_map('gs', 'lua vim.lsp.buf.document_symbol()')
        buf_map('ga', 'lua vim.lsp.buf.code_action()')
        buf_map('<leader>rn', 'lua vim.lsp.buf.rename()')

        buf_map('<C-Space>', 'lua vim.lsp.buf.hover()')

        --- diagnostics navegation mappings
        buf_map('gE', 'lua vim.lsp.diagnostic.goto_prev()')
        buf_map('ge', 'lua vim.lsp.diagnostic.goto_next()')

    end

    -- enable snippets
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Rust
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {'documentation', 'detail', 'additionalTextEdits'}
    }

    capabilities.experimental = {}
    capabilities.experimental.hoverActions = true

    lsp.rust_analyzer
        .setup({capabilities = capabilities, on_attach = on_attach})

    local function setup_rust_tools()
        require'rust-tools'.setup({
            autoSetHints = true,
            runnables = {use_telescope = true},
            inlay_hints = {show_parameter_hints = true}
        })
        require'rust-tools-debug'.setup()
    end

    pcall(setup_rust_tools)

    -- Python
    lsp.pyright.setup {on_attach = on_attach}
    -- Typescript
    lsp.tsserver.setup {on_attach = on_attach}

    vim.lsp.handlers['textDocument/codeAction'] =
        require'lsputil.codeAction'.code_action_handler

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            update_in_insert = true
        })

    --- Use <Tab> and <S-Tab> to navigate through popup menu
    -- noremap('<Tab>', "pumvisible() ? '<C-n>' : '<Tab>'", 'i', true)
    -- noremap('<S-Tab>', "pumvisible() ? '<C-p>' : '<S-Tab>'", 'i', true)

    --- auto-commands
    cmd "au BufWritePre *.rs lua vim.lsp.buf.formatting_sync()"
    -- cmd "au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()"

    --- lightbulb

    vim.fn.sign_define("LightBulbSign",
                       {text = "💡", texthl = "LspDiagnosticsSignWarning"})

    cmd [[ autocmd CursorHold,CursorHoldI * lua mlem.LightBulbFunc()]]

    mlem.LightBulbFunc = function()
        require("nvim-lightbulb").update_lightbulb({sign = {enabled = true}})
    end

    -- Autocomplete
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

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

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
        elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
            return t "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"
        -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
        --     return t "<Plug>(vsnip-expand-or-jump)"
        elseif check_back_space() then
            return t "<Tab>"
        else
            return vim.fn['compe#complete']()
        end
    end
    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
        elseif fn["UltiSnips#CanJumpBackwards"]() == 1 then
            return t "<C-R>=UltiSnips#JumpBackwards()<CR>"
        -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        --     return t "<Plug>(vsnip-jump-prev)"
        else
            return t "<S-Tab>"
        end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()",
                            {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()",
                            {expr = true})
    noremap('<C-Space>', "compe#complete()", 'i', true)
    noremap('<CR>>', "compe#confirm('<CR>')", 'i', true)
    noremap('<C-e>', "compe#close('<C-e>')", 'i', true)
    noremap('<C-f>', "compe#scroll({ 'delta': +4 })", 'i', true)
    noremap('<C-d>', "compe#scroll({ 'delta': -4 })", 'i', true)

end


do -- Snippets
    g.UltiSnipsExpandTrigger = "<Enter>"
    -- g.UltiSnipsJumpForwardTrigger = "<C-j>"
    -- g.UltiSnipsJumpBackwardTrigger = "<C-k>"

    map("<Leader>V", "UltiSnipsEdit")
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
                }
            }
        },
        extensions = {
            media_files = {
                file_types = {"png", "jpg", "mp4", "webm", "pdf"},
                find_cmd = "rg"
            }
        }
    }
    telescope.load_extension('media_files')
    -- telescope.load_extension('fzy_native')
    telescope.load_extension('project')
    telescope.load_extension('ultisnips')
    noremap('<leader>ff', 'Telescope find_files')
    noremap('<leader>fg', 'Telescope live_grep')
    noremap('<leader>fb', 'Telescope buffers')
    noremap('<leader>fh', 'Telescope help_tags')
    noremap('<leader>fm', 'Telescope media_files media_files')
    noremap('<leader>fp', 'Telescope project project')
    noremap('<leader>fs', 'Telescope ultisnips ultisnips')
end


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

do --- Rnvimr
    g.rnvimr_enable_ex = 1
    g.rnvimr_enable_bw = 1

    noremap('<M-o>', 'RnvimrToggle')
end

do -- commentary
    noremap('<leader>/', 'Commentary')
    noremap('<leader>/', ':Commentary<CR>', 'v')
    -- map('<leader>/', 'Commentary', 'v')
    -- cmd 'vnoremap <leader>/ :Commentary<CR>'
end

-- require("which-key").setup {}

require('lspkind').init({
    with_text = true,
    symbol_map = {
        Text = '',
        Method = 'ƒ',
        Function = '',
        Constructor = '',
        Variable = '',
        Class = '',
        Interface = 'ﰮ',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '了',
        Keyword = '',
        Snippet = '﬌',
        Color = '',
        File = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = ''
    }
})

do end

require('gitsigns').setup()
