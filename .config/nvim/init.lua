local banner = {
'                                                                                             ',
'                                                                                             ',
'     ██      ███████ ████████ ███████      ██████  ██████  ██████  ██ ███    ██  ██████      ',
'     ██      ██         ██    ██          ██      ██    ██ ██   ██ ██ ████   ██ ██           ',
'     ██      █████      ██    ███████     ██      ██    ██ ██   ██ ██ ██ ██  ██ ██   ███     ',
'     ██      ██         ██         ██     ██      ██    ██ ██   ██ ██ ██  ██ ██ ██    ██     ',
'     ███████ ███████    ██    ███████      ██████  ██████  ██████  ██ ██   ████  ██████      ',
'                                                                                             ',
'                                                                                             ',
'                                                                                             ',
'                                                                                             ',
}
local vim = vim
local cmd, opt, g, fn = vim.cmd, vim.opt, vim.g, vim.fn

local keymap = require("keymap")

-- cmd 'source ~/.vimrc'
Mlem = Mlem or {}
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
-- FIX: Change todo
-- WARN: hahahaah
-- NOTE: sdsds
-- TODO: test todo
local c = function(rhs) return '<cmd>' .. rhs .. '<cr>' end
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
    'hrsh7th/vim-vsnip-integ';

    --- Telescope
    'nvim-lua/popup.nvim';
    'nvim-telescope/telescope.nvim';
    'nvim-telescope/telescope-media-files.nvim';
    'nvim-telescope/telescope-project.nvim';
    -- 'nvim-telescope/telescope-fzy-native.nvim';
    -- 'fhill2/telescope-ultisnips.nvim';

    --- Misc
    'hoob3rt/lualine.nvim';
    'akinsho/nvim-bufferline.lua';
    'mbbill/undotree';
    -- 'Yggdroot/indentLine';
	{'lukas-reineke/indent-blankline.nvim', branch = 'lua'};
    'numToStr/Navigator.nvim';
    -- 'folke/which-key.nvim';
})
-- LuaFormatter on

local create_missing_dirs = function()
    local home = os.getenv('HOME')
    local sep = package.config:sub(1, 1)

    local join = function(segments)
        return table.concat(segments, sep)
    end
    Mlem.path = Mlem.path or {}
    local cache_path = join {home, '.cache', 'nvim'}
    local session_path = join {cache_path, 'session'}
    local spell_path = join {cache_path, 'spell'}
    local undo_path = join {home, '.undodir'}
    Mlem.path.home = home
    Mlem.path.sep = sep

    local paths = {
        session = session_path,
        spell = spell_path,
        undo = undo_path
    }

    for _, p in pairs(paths) do
        if fn.isdirectory(p) == 0 then os.execute('mkdir -p ' .. p) end
    end
    Mlem.paths = paths
end
do --- General
    create_missing_dirs()
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
    opt.shortmess:append('cI')
    opt.hlsearch = true
    opt.pumblend = 10
    opt.signcolumn = 'number'
    opt.showtabline = 2
    opt.timeoutlen = 500
    opt.ttimeoutlen = -1
    opt.sessionoptions:remove('folds')
    opt.showbreak = ' ↳  '
    opt.listchars = 'tab:→ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨'

    opt.undofile = true
    opt.undodir = Mlem.paths.undo

    opt.termguicolors = true
    cmd 'colorscheme dracula'

    -- Dashboard
    g.dashboard_default_executive = 'telescope'
    g.dashboard_session_directory = Mlem.paths.session
    g.dashboard_custom_header = banner
    g.dashboard_custom_footer = {'', '', '', '', '', '', '', 'https://github.com/langbamit'}
    cmd [[ autocmd FileType dashboard set showtabline=0 laststatus=0 | autocmd BufLeave <buffer> set showtabline=2 laststatus=2 ]]

    g.indent_blankline_filetype_exclude = { 'dashboard' }

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

    keymap.nnoremap {'<M-u>', c "UndotreeToggle"}

    require('colorizer').setup()

    require('spectre').setup {}
    require('lsp-rooter').setup {}

    keymap.nnoremap { "<leader>sr", c "lua require('spectre').open()" }

    -- search current word
    keymap.nnoremap { "<leader>srw", "viw:lua require('spectre').open_visual()<CR>" }
    keymap.vnoremap { "<leader>s", c "lua require('spectre').open_visual()" }

    -- search in current file
    -- keymap.nnoremap  <leader>sp viw:lua require('spectre').open_file_search()<cr>

    require('nvim_comment').setup {
        line_mapping = " cl",
        operator_mapping = " c"
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

    --- Miscellaneous
    require('Navigator').setup()
    keymap.nnoremap { '<m-h>', c "lua require('Navigator').left()", silent = true}
    keymap.nnoremap { '<m-j>', c "lua require('Navigator').down()", silent = true}
    keymap.nnoremap { '<m-k>', c "lua require('Navigator').up()", silent = true}
    keymap.nnoremap { '<m-l>', c "lua require('Navigator').right()", silent = true}


    cmd [[
function! SmartQuit()
    let num_buffers = len(getbufinfo({'buflisted':1}))
    if num_buffers == 1
      try
        execute ":silent quit"
      catch /E37:/
        " Unwritten changes
        echo "E37: Discard changes?  Y|y = Yes, N|n = No, W|w = Write and quit: "
        let ans = nr2char(getchar())
        if ans == "y" || ans == "Y"
          execute "quit!"
        elseif  ans == "w" || ans == "W"
          execute "write"
          execute "quit"
        else
          call feedkeys('\<ESC>')
        endif
      endtry
    else
      try
        execute "bd"
      catch /E89:/
        " Unwritten changes
        echo "E89: Discard changes?  Y|y = Yes, N|n = No, W|w = Write and quit: "
        let ans = nr2char(getchar())
        if ans == "y" || ans == "Y"
          execute "bd!"
        elseif  ans == "w" || ans == "W"
          execute "write"
          execute "bd"
        else
          call feedkeys('\<ESC>')
        endif
      endtry
    endif
endfunction

nnoremap <leader>qq :call SmartQuit()<CR>
]]
    g.indent_blankline_char = '┊'
end

require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    context_commentstring = {enable = true},
    autopairs = {enable = true},
    autotag = {enable = true},
    nvim_lsp = {enable = true},
    highlight = {enable = true},
    textobjects = {
        select = {
            enable = true, lookahead = true, keymaps= {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@comment.outer",
            }
        },
        move = {
            enable = true,
            goto_next_start = {
                [']m'] = '@function.outer'
            },
            goto_previous_start = {
                ['[m'] = '@function.outer'
            }
        }
    },
    textsubjects = {enable = true, keymaps = {['.'] = 'textsubjects-smart'}},
    playground = {enable = true}
}

do -- LSP & Autocomplete
    local lsp = require('lspconfig')
    local illuminate = require('illuminate')
    local npairs = require('nvim-autopairs')

    local on_attach = function(client, bufnr)
        local buf_map = function(opts, mode)
            mode = mode or 'n'
            keymap[mode .. 'noremap'](vim.tbl_extend("force", opts, {silent = true, buffer = bufnr}))
        end
        if client.resolved_capabilities.document_highlight then
            cmd([[
                hi LspReferenceRead cterm=bold ctermbg=red guibg=#4C566A
                hi LspReferenceText cterm=bold ctermbg=red guibg=#4C566A
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=#4C566A
                augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]])
        end
        -- SignatureHelp
        require('lsp_signature').on_attach {
            bind = true,
            hint_prefix = "",
            handler_opts = {border = "single"}
        }

        illuminate.on_attach(client)
        keymap.nnoremap {'<leader>v', c "echo stdpath('data')"}

        --- GOTO Mappings
        buf_map {'gd', function() vim.lsp.buf.definition() end, as_command='LspDefination'}
        buf_map {'gD', function() vim.lsp.buf.declaration() end, as_command='LspDeclaration'}
        buf_map {'gr', function() vim.lsp.buf.references() end, as_command='LspReferences'}
        buf_map {'gs', function() vim.lsp.buf.document_symbol() end, as_command='LspDocumentSymbol'}
        buf_map {'ga', function() vim.lsp.buf.code_action() end, as_command='LspCodeAction'}
        buf_map {'<leader>rn', function() vim.lsp.buf.rename() end, as_command='LspRename'}
        buf_map {'<leader>F', function() vim.lsp.buf.formatting() end, as_command='LspFormatting'}

        buf_map {'<C-Space>', function() vim.lsp.buf.hover() end, as_command='LspHover'}

        --- diagnostics navegation mappings
        buf_map {'gE', function() vim.lsp.diagnostic.goto_prev() end, as_command='LspDiagnosticGotoPrev'}
        buf_map {'ge', function() vim.lsp.diagnostic.goto_next() end, as_command='LspDiagnosticGotoNext'}

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

    lsp.rust_analyzer.setup({capabilities = capabilities, on_attach = on_attach})

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
    lsp.svelte.setup {on_attach = on_attach}
    -- cmd [[ au BuffReadPost *.svelte set syntax=html ]]
    -- Lua (install with yay -S lua-language-server)
    local sumneko_binary = 'lua-language-server'
    lsp.sumneko_lua.setup {
        cmd = { sumneko_binary},
        on_attach = on_attach}

    -- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                     {virtual_text = true, signs = true, update_in_insert = true})

    --- auto-commands
    -- cmd "au BufWritePre *.rs lua vim.lsp.buf.formatting_sync()"
    -- cmd "au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()"

    --- lightbulb

    vim.fn.sign_define("LightBulbSign", {text = "💡", texthl = "LspDiagnosticsSignWarning"})

    cmd [[ autocmd CursorHold,CursorHoldI * lua Mlem.LightBulbFunc()]]

    Mlem.LightBulbFunc = function()
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

    keymap.imap {"<Tab>", "v:lua.tab_complete()", expr = true}
    keymap.smap {"<Tab>", "v:lua.tab_complete()", expr = true}
    keymap.imap {"<S-Tab>", "v:lua.s_tab_complete()", expr = true}
    keymap.smap {"<S-Tab>", "v:lua.s_tab_complete()", expr = true}

    npairs.setup {

    }

    g.user_emmet_install_global = 0
    g.user_emmet_install_command = 0
    g.user_emmet_mode = 'i'

    g.completion_confirm_key = ""
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

    keymap.inoremap {'<C-Space>', "compe#complete()", expr = true}
    keymap.inoremap {'<CR>>', "v:lua.Mlem.completion_confirm()", expr = true}
    keymap.inoremap {'<C-e>', "compe#close('<C-e>')", expr = true}
    keymap.inoremap {'<C-f>', "compe#scroll({ 'delta': +4 })", expr = true}
    keymap.inoremap {'<C-d>', "compe#scroll({ 'delta': -4 })", expr = true}

    keymap.nnoremap {'<A-n>', function() illuminate.next_reference {wrap = true} end}
    keymap.nnoremap {'<A-S-n>', function() illuminate.next_reference {reverse = true, wrap = true} end}
end

do -- Snippets
    g.UltiSnipsExpandTrigger = "<C-j>"
    -- g.UltiSnipsJumpForwardTrigger = "<C-j>"
    -- g.UltiSnipsJumpBackwardTrigger = "<C-k>"

    keymap.nmap {"<Leader>V", "UltiSnipsEdit", silent = true}
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
            media_files = {file_types = {"png", "jpg", "mp4", "webm", "pdf"}, find_cmd = "rg"}
        }
    }
    telescope.load_extension('media_files')
    -- telescope.load_extension('fzy_native')
    telescope.load_extension('project')
    keymap.nnoremap {'<leader>ff', c 'Telescope find_files', silent = true}
    keymap.nnoremap {'<leader>fo', c 'Telescope oldfiles', silent = true}
    keymap.nnoremap {'<leader>fg', c 'Telescope live_grep', silent = true}
    keymap.nnoremap {'<leader>fb', c 'Telescope buffers', silent = true}
    keymap.nnoremap {'<leader>fh', c 'Telescope help_tags', silent = true}
    keymap.nnoremap {'<leader>fm', c 'Telescope media_files media_files', silent = true}
    keymap.nnoremap {'<leader>fp', c 'Telescope project project', silent = true}
    keymap.nnoremap {'<leader>fc', c 'TodoTelescope', silent = true}
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

    keymap.nnoremap {'<M-o>', c'RnvimrToggle', silent = true}
end

-- require("which-key").setup {
--     triggers_blacklist = {
--         i = {'j', 'k', '<cr>'}
--     }
-- }

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


require('gitsigns').setup()
