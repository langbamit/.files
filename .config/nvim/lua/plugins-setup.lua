local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd("packadd packer.nvim")

local packer = require('packer')

packer.init({git = {clone_timeout = 350}})

packer.startup(function(use)
    use {'wbthomason/packer.nvim', opt = true} -- Manager itself to avoid clean
    use {
        'Mofiqul/dracula.nvim',
        config = function()
            vim.cmd [[
                 colorscheme dracula
        ]]
        end,
        disable = not nocode()
    }
    use {"folke/lua-dev.nvim", disable = not nocode()}
    use {"kabouzeid/nvim-lspinstall", disable = not nocode()}
    use {"kyazdani42/nvim-web-devicons", disable = not nocode()}
    use {
        'antoinemadec/FixCursorHold.nvim',
        event = 'VimEnter',
        setup = function() vim.g.cursorhold_updatetime = 100 end
    } -- Fix this issue https://github.com/neovim/neovim/issues/12587
    use {
        'b3nj5m1n/kommentary',
        config = function()
            require("kommentary.config").configure_language("default",
                                                            {prefer_single_line_comments = true})
        end,
        disable = not nocode()
    }
    use {'tpope/vim-speeddating', setup = function() vim.g.speeddating_no_mappings = 1 end}
    use {
        'AndrewRadev/switch.vim',
        requires = 'tpope/vim-speeddating',
        config = function()
            vim.keymap.nnoremap {'<Plug>SpeedDatingFallbackUp', '<c-a>'}
            vim.keymap.nnoremap {'<Plug>SpeedDatingFallbackDown', '<c-x>'}
            vim.keymap.nnoremap {
                '<c-a>',
                [[:if !switch#Switch() <bar> call speeddating#increment(v:count1) <bar> endif<cr>]]
            }
            vim.keymap.nnoremap {
                '<c-x>',
                [[:if !switch#Switch({'reverse': 1}) <bar> call speeddating#increment(-v:count1) <bar> endif<cr>]]
            }
        end
    }
    -- https://github.com/norcalli/nvim-colorizer.lua
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup(nil, {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes: foreground, background
                mode = "background" -- Set the display mode.
            })
            vim.cmd([[
                autocmd ColorScheme * lua package.loaded['colorizer'] = nil; require('colorizer').setup(); require('colorizer').attach_to_buffer(0)
            ]])
        end,
        disable = not nocode()
    }
    use {'tpope/vim-repeat'}
    use {'tweekmonster/startuptime.vim', cmd = 'StartupTime', disable = not nocode()}
    use {
        'machakann/vim-sandwich',
        config = function()
            vim.cmd [[
            runtime macros/sandwich/keymap/surround.vim
        ]]
            vim.keymap.xmap {'is', '<Plug>(textobj-sandwich-query-i)'}
            vim.keymap.xmap {'as', '<Plug>(textobj-sandwich-query-a)'}
            vim.keymap.omap {'is', '<Plug>(textobj-sandwich-query-i)'}
            vim.keymap.omap {'as', '<Plug>(textobj-sandwich-query-a)'}

            -- Text objects to select the nearest surrounded text automatically.
            vim.keymap.xmap {'iss', '<Plug>(textobj-sandwich-auto-i)'}
            vim.keymap.xmap {'ass', '<Plug>(textobj-sandwich-auto-a)'}
            vim.keymap.omap {'iss', '<Plug>(textobj-sandwich-auto-i)'}
            vim.keymap.omap {'ass', '<Plug>(textobj-sandwich-auto-a)'}

            -- Textobjects to select a text surrounded by same characters user input.
            vim.keymap.xmap {'im', '<Plug>(textobj-sandwich-literal-query-i)'}
            vim.keymap.xmap {'am', '<Plug>(textobj-sandwich-literal-query-a)'}
            vim.keymap.omap {'im', '<Plug>(textobj-sandwich-literal-query-i)'}
            vim.keymap.omap {'am', '<Plug>(textobj-sandwich-literal-query-a)'}
        end
    }
    use {'danilamihailov/vim-tips-wiki', disable = not nocode()}

    use {'mattn/emmet-vim', disable = not nocode()}
    -- https://github.com/numToStr/BufOnly.nvim
    use {'numtostr/BufOnly.nvim', cmd = 'BufOnly', disable = not nocode()}
    use {
        'AndrewRadev/sideways.vim',
        cmd = {'SidewaysLeft', 'SidewaysRight', 'SidewaysJumpLeft', 'SidewaysJumpRight'}
    } -- allows to move functions parameters
    use 'AndrewRadev/splitjoin.vim' -- allows to split one liner to multi lines
    use {
        "phaazon/hop.nvim",
        keys = {"gh", "s"},
        cmd = {"HopWord", "HopChar1"},
        config = function()
            vim.keymap.nmap {"gh", with_cmd "HopWord"}
            -- require("util").nmap("s", "<cmd>HopChar1<CR>")
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({})
        end,
        disable = not nocode()
    }
    use {'ChristianChiarulli/vscode-easymotion', config = function ()
            vim.keymap.nmap {"gh", "<Plug>(easymotion-w)"}
    end, disable = nocode()}
    
    --- Snippets
    use {'L3MON4D3/Luasnip', disable = not nocode()}
    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {check_ts = true} end,
        disable = not nocode()
    }
    use {'yuki-yano/zero.nvim', config = function() require('zero').setup {} end, disable = not nocode()}
    use {'MattesGroeger/vim-bookmarks', config = function() end, disable = not nocode()}
    use {"simrat39/symbols-outline.nvim", cmd = {"SymbolsOutline"}, disable = not nocode()}
    -- Debugger
    use {'mfussenegger/nvim-dap', disable = not nocode()}
    -- https://github.com/mg979/vim-visual-multi
    use {'mg979/vim-visual-multi', disable = not nocode()}
    -- https://github.com/sindrets/diffview.nvim
    use {
        "sindrets/diffview.nvim",
        cmd = {"DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles"},
        config = function() require("diffview").setup({}) end,
        disable = not nocode()
    }
    -- https://github.com/ahmedkhalf/lsp-rooter.nvim
    -- use {'airblade/vim-rooter'}
    -- https://github.com/karb94/neoscroll.nvim
    use {
        'karb94/neoscroll.nvim',
        config = function()
            require('neoscroll').setup()

            local map = {}

            map["<C-u>"] = {"scroll", {"-vim.wo.scroll", "true", "80"}}
            map["<C-d>"] = {"scroll", {"vim.wo.scroll", "true", "80"}}
            map["<C-b>"] = {"scroll", {"-vim.api.nvim_win_get_height(0)", "true", "250"}}
            map["<C-f>"] = {"scroll", {"vim.api.nvim_win_get_height(0)", "true", "250"}}
            map["<C-y>"] = {"scroll", {"-0.10", "false", "80"}}
            map["<C-e>"] = {"scroll", {"0.10", "false", "80"}}
            map["zt"] = {"zt", {"150"}}
            map["zz"] = {"zz", {"150"}}
            map["zb"] = {"zb", {"150"}}

            require("neoscroll.config").set_mappings(map)
        end,
        disable = not nocode()
    }
    --- Git
    -- https://github.com/lewis6991/gitsigns.nvim
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = {
                        hl = "GitSignsAdd",
                        text = "▍",
                        numhl = "GitSignsAddNr",
                        linehl = "GitSignsAddLn"
                    },
                    change = {
                        hl = "GitSignsChange",
                        text = "▍",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn"
                    },
                    delete = {
                        hl = "GitSignsDelete",
                        text = "▸",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn"
                    },
                    topdelete = {
                        hl = "GitSignsDelete",
                        text = "▾",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn"
                    },
                    changedelete = {
                        hl = "GitSignsChange",
                        text = "▍",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn"
                    }
                },
                keymaps = {
                    -- Default keymap options
                    noremap = true,
                    buffer = true,
                    ["n ]c"] = {
                        expr = true,
                        "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"
                    },
                    ["n [c"] = {
                        expr = true,
                        "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"
                    },
                    ["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
                    ["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                    ["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
                    ["n <leader>ghR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
                    ["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
                    ["n <leader>ghb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
                    -- Text objects
                    ["o ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
                    ["x ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
                }
            })
        end,
        disable = not nocode()
    }
    use {"npxbr/glow.nvim", branch = "main", cmd = "Glow", disable = not nocode()}
    use {
        'folke/lsp-colors.nvim',
        config = function() require('lsp-colors').setup {} end,
        disable = not nocode()
    }
    -- https://github.com/
    use {
        'langbamit/git-blame.nvim',
        setup = function() vim.g.gitblame_virtual_text = 0 end,
        event = 'VimEnter',
        disable = not nocode()
    }
    use {
        "folke/trouble.nvim",
        event = "BufReadPre",
        requires = "kyazdani42/nvim-web-devicons",
        cmd = {"TroubleToggle", "Trouble"},
        config = function() require("trouble").setup({auto_open = false}) end,
        disable = not nocode()
    }
    -- https://github.com/mbbill/undotree
    use {
        'mbbill/undotree',
        cmd = {'UndotreeToggle', 'UndotreeShow'},
        config = function()
            vim.keymap.nnoremap {'<leader>tu', with_cmd "UndotreeToggle"}
            vim.keymap.nnoremap {'<leader>ou', with_cmd "UndotreeShow"}
        end,
        disable = not nocode()
    }
    -- https://github.com/h-youhei/vim-ibus
    -- use {
    --     'h-youhei/vim-ibus',
    --     config = function()
    --         vim.g['ibus#layout'] = 'xkb:us::eng'
    --         vim.g['ibus#engine'] = 'Bamboo'
    --     end
    -- }

    -- end);local a = function(e)end;a(function ()
    -- Terminal
    use({
        "akinsho/nvim-toggleterm.lua",
        config = function()
            require("toggleterm").setup({
                size = 20,
                hide_numbers = true,
                open_mapping = [[<M-`>]],
                shade_filetypes = {},
                shade_terminals = false,
                shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
                start_in_insert = true,
                persist_size = true,
                direction = "horizontal"
            })

            local Terminal = require('toggleterm.terminal').Terminal
            -- Lazygit
            local lazygit = Terminal:new({cmd = 'lazygit', dir = 'git_dir', direction = 'float'})

            vim.keymap.nnoremap {'<leader>gl', function() lazygit:toggle() end, silent = true}

            -- Hide number column for
            -- vim.cmd [[au TermOpen * setlocal nonumber norelativenumber]]

            -- Esc twice to get to normal mode
            vim.cmd([[tnoremap <esc><esc> <C-\><C-N>]])
        end,
        disable = not nocode()
    })

    -- https://github.com/kevinhwang91/rnvimr
    use {
        'kevinhwang91/rnvimr',
        config = function() -- g.rnvimr_enable_ex = 1
            -- g.rnvimr_enable_bw = 1
            vim.keymap.nnoremap {'<M-o>', with_cmd 'RnvimrToggle', silent = true}
        end,
        disable = not nocode()
    }
    use {
        'edluffy/specs.nvim',
        config = function()
            require("specs").setup({
                show_jumps = true,
                min_jump = 10,
                popup = {
                    delay_ms = 0, -- delay before popup displays
                    inc_ms = 20, -- time increments used for fade/resize effects
                    blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
                    width = 20,
                    winhl = "PMenu",
                    fader = require("specs").linear_fader,
                    resizer = require("specs").shrink_resizer
                },
                ignore_filetypes = {},
                ignore_buftypes = {nofile = true}
            })
        end,
        disable = not nocode()
    }
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_char = '┊'
            vim.g.indent_blankline_filetype_exclude = {
                'dashboard', 'NvimTree', 'help', 'packer', 'Trouble'
            }
            vim.g.indent_blankline_buftype_exclude = {'terminal', 'nofile'}
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indent_blankline_show_trailing_blankline_indent = false
            vim.g.indent_blankline_show_current_context = true
            vim.g.indent_blankline_context_patterns = {
                "class", "return", "function", "method", "^if", "^while", "jsx_element", "^for",
                "^object", "^table", "block", "arguments", "if_statement", "else_clause",
                "jsx_element", "jsx_self_closing_element", "try_statement", "catch_clause",
                "import_statement", "operation_type"
            }
            -- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
            vim.wo.colorcolumn = "99999"
        end,
        disable = not nocode()
    }
    --- LSP & language support
    use {'glepnir/lspsaga.nvim', disable = not nocode()}
    use {'onsails/lspkind-nvim', disable = not nocode()}
    use {'RRethy/vim-illuminate', disable = not nocode()}
    use {'RishabhRD/nvim-lsputils', disable = not nocode()}
    use {'simrat39/rust-tools.nvim', disable = not nocode()}
    use {'kosayoda/nvim-lightbulb', disable = not nocode()}
    use {'ray-x/lsp_signature.nvim', disable = not nocode()}
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'onsails/lspkind-nvim', 'kosayoda/nvim-lightbulb', 'ray-x/lsp_signature.nvim',
            'RRethy/vim-illuminate', 'simrat39/rust-tools.nvim', 'RishabhRD/popfix',
            'RishabhRD/nvim-lsputils', 'glepnir/lspsaga.nvim'
        },
        config = function() require('up-config.lsp')() end,
        disable = not nocode()
    }

    -- https://github.com/hoob3rt/lualine.nvim
    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            local location = function() return '(Ln %l/%L, Col %c)' end

            require('lualine').setup {
                options = {
                    theme = 'dracula-nvim',
                    section_separators = '',
                    component_separators = ''
                },
                sections = {
                    lualine_b = {'branch', 'b:gitsigns_status', 'b:gitblame_status'},
                    lualine_c = {'filename', location},
                    lualine_x = {
                        require('spectre.state_utils').status_line, 'encoding', 'fileformat',
                        'filetype'
                    },
                    lualine_y = {},
                    lualine_z = {}
                }
            }
        end,
        disable = not nocode()
    }
    -- https://github.com/akinsho/nvim-bufferline.lua
    use {
        'akinsho/nvim-bufferline.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require"bufferline".setup {
                options = {
                    separator_style = {'', ''},
                    tab_size = 22,
                    enforce_regular_tabs = true,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    always_show_bufferline = true,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(_, _, diagnostics_dict)
                        local s = " "
                        for e, n in pairs(diagnostics_dict) do
                            local sym = e == "error" and " " or
                                            (e == "warning" and " " or " ")
                            s = s .. sym .. n .. (n < #diagnostics_dict and " " or "")
                        end
                        return s
                    end,
                    custom_areas = {
                        right = function()
                            local result = {}
                            local error = vim.lsp.diagnostic.get_count(0, [[Error]])
                            local warning = vim.lsp.diagnostic.get_count(0, [[Warning]])
                            local info = vim.lsp.diagnostic.get_count(0, [[Information]])
                            local hint = vim.lsp.diagnostic.get_count(0, [[Hint]])
                            if error ~= 0 then
                                result[#result + 1] = {text = "  " .. error, guifg = "#EC5241"}
                            end

                            if warning ~= 0 then
                                result[#result + 1] {text = "  " .. warning, guifg = "#EFB839"}
                            end

                            if hint ~= 0 then
                                result[#result + 1] = {text = "  " .. hint, guifg = "#A3BA5E"}
                            end

                            if info ~= 0 then
                                result[#result + 1] = {text = "  " .. info, guifg = "#7EA9A7"}
                            end
                            result[#result + 1] = {text = " Uther Pally ", guifg = "#FFFFFF"}
                            return result
                        end
                    }
                }
            }
        end,
        disable = not nocode()
    }

    use {
        'folke/todo-comments.nvim',
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require'todo-comments'.setup {
                keywords = {TODO = {alt = {"WIP"}}},
                highlight = {keyword = "bg"},
                colors = {
                    error = {"LspDiagnosticsDefaultError", "ErrorMsg", "#ff5555"},
                    warning = {"LspDiagnosticsDefaultWarning", "WarningMsg", "#ffb86c"},
                    info = {"LspDiagnosticsDefaultInformation", "#8be9fd"},
                    hint = {"LspDiagnosticsDefaultHint", "#50fa7b"},
                    default = {"Identifier", "#bd93f9"}
                }
            }
        end,
        disable = not nocode()
    }

    use {
        'windwp/nvim-spectre',
        requires = {"nvim-lua/plenary.nvim", 'nvim-lua/popup.nvim'},
        config = function()
            require('spectre').setup {}

            vim.keymap.nnoremap {
                '<leader>os',
                with_cmd "lua require('spectre').open()",
                silent = true
            }
            -- search current word
            vim.keymap.nnoremap {"<leader>srw", with_cmd "lua require('spectre').open_visual()"}
            vim.keymap.vnoremap {"<leader>srw", with_cmd "lua require('spectre').open_visual()"}

            -- search in current file
            vim.keymap.nnoremap {"<leader>sp", with_cmd "lua require('spectre').open_file_search()"}
        end,
        disable = not nocode()
    }
    use {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        setup = function()
            vim.g.dashboard_default_executive = 'telescope'
            vim.g.dashboard_enable_session = 0
            vim.g.dashboard_custom_header = Mlem.banner
            vim.g.dashboard_custom_footer = {
                '', '', '', '', '', '', '', 'https://github.com/langbamit'
            }
            vim.g.dashboard_custom_section = {
                a = {description = {'  Find File          '}, command = 'Telescope find_files'},
                b = {description = {'  Recently Used Files'}, command = 'Telescope oldfiles'},
                c = {description = {'  Load Last Session  '}, command = 'LoadLastSession'},
                d = {description = {'  Find Word          '}, command = 'Telescope live_grep'}
                -- e = {description = {'  Settings           '}, command = ':e '..CONFIG_PATH..'/lv-settings.lua'}
            }
        end,
        config = function()

            vim.cmd [[ autocmd FileType dashboard setlocal showtabline=0 laststatus=0 nowrap | autocmd BufLeave <buffer> set showtabline=2 laststatus=2 ]]

        end,
        disable = not nocode()
    }

    use {
        'kyazdani42/nvim-tree.lua',
        cmd = {"NvimTreeToggle", "NvimTreeClose", "NvimTreeOpen"},
        keys = '<space>oe',
        requires = 'kyazdani42/nvim-web-devicons',
        setup = function()
            vim.g.nvim_tree_width = 40
            vim.g.nvim_tree_follow = 1
            vim.g.nvim_tree_gitignore = 1
            vim.g.nvim_tree_ignore = {'.git', 'node_modules'}
            vim.g.nvim_tree_indent_markers = 0
            vim.g.nvim_tree_disable_netrw = 1
            vim.g.nvim_tree_auto_open = 0
            vim.g.nvim_tree_auto_close = 0
            vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
            vim.g.nvim_tree_lsp_diagnostics = 0
        end,
        config = function()
            vim.keymap.nnoremap {'<leader>oe', with_cmd "NvimTreeOpen", silent = true}
            vim.keymap.nnoremap {'<leader>te', with_cmd "NvimTreeToggle", silent = true}
            -- require("nvim-tree.events").on_nvim_tree_ready(function()
            --     vim.cmd("NvimTreeRefresh")
            -- end)
        end,
        disable = not nocode()
    }

    -- https://github.com/folke/which-key.nvim
    use {'folke/which-key.nvim', config = function() require('up-config.keys') end, disable = not nocode()}
    --- Tree-sitter
    -- https://github.com/
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = "all",
                context_commentstring = {enable = true},
                autopairs = {enable = true},
                autotag = {enable = true},
                nvim_lsp = {enable = true},
                highlight = {enable = true},
                rainbow = {enable = true},
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@comment.outer"
                        }
                    },
                    move = {
                        enable = true,
                        goto_next_start = {[']m'] = '@function.outer'},
                        goto_previous_start = {['[m'] = '@function.outer'}
                    }
                },
                textsubjects = {enable = true, keymaps = {['.'] = 'textsubjects-smart'}},
                playground = {enable = true}
            }
            vim.opt.foldmethod = "expr"
            vim.opt.foldlevel = 6
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
        end,
        disable = not nocode()
    }
    -- https://github.com/
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = "nvim-treesitter/nvim-treesitter",
        disable = not nocode()
    }
    use {'nvim-treesitter/playground', requires = "nvim-treesitter/nvim-treesitter", disable = not nocode()}
    use {
        'RRethy/nvim-treesitter-textsubjects',
        requires = "nvim-treesitter/nvim-treesitter",
        disable = not nocode()
    }
    use {
        'JoosepAlviste/nvim-ts-context-commentstring',
        requires = "nvim-treesitter/nvim-treesitter",
        disable = not nocode()
    }
    use {'windwp/nvim-ts-autotag', requires = "nvim-treesitter/nvim-treesitter", disable = not nocode()}
    use {'p00f/nvim-ts-rainbow', requires = "nvim-treesitter/nvim-treesitter", disable = not nocode()}

    use {'nvim-telescope/telescope-project.nvim', disable = not nocode()}
    use {'nvim-telescope/telescope-media-files.nvim', disable = not nocode()}
    use {'tom-anders/telescope-vim-bookmarks.nvim', disable = not nocode()}
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim',
            {
                'nvim-telescope/telescope-fzy-native.nvim',
                run = 'git submodule update --init --recursive',
                disable = not nocode()
            },
            {'tom-anders/telescope-vim-bookmarks.nvim', requires = 'MattesGroeger/vim-bookmarks'},
            'nvim-telescope/telescope-project.nvim', 'nvim-telescope/telescope-media-files.nvim'
        },
        config = function()
            local telescope = require('telescope');
            local actions = require('telescope.actions')

            telescope.setup {
                defaults = {
                    vimgrep_arguments = {
                        'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
                        '--column', '--smart-case', '--hidden'
                    },
                    -- default mappings
                    -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
                    mappings = {i = {["<Esc>"] = actions.close}},
                    prompt_prefix = " ",
                    selection_caret = " ",
                    winblend = 10
                },
                extensions = {
                    media_files = {
                        file_types = {"png", "jpg", "mp4", "webm", "pdf"},
                        find_cmd = "rg"
                    },
                    fzy_native = {override_generic_sorter = false, override_file_sorter = true}
                }
            }
            telescope.load_extension('media_files')
            telescope.load_extension('fzy_native')
            telescope.load_extension('project')
            telescope.load_extension('vim_bookmarks')

            vim.keymap.nnoremap {'<leader>ff', with_cmd 'Telescope find_files', silent = true}
            vim.keymap.nnoremap {'<leader>fo', with_cmd 'Telescope oldfiles', silent = true}
            vim.keymap.nnoremap {'<leader>fg', with_cmd 'Telescope live_grep', silent = true}
            vim.keymap.nnoremap {'<leader>fb', with_cmd 'Telescope buffers', silent = true}
            -- vim.keymap.nnoremap {'<leader>fh', with_cmd 'Telescope help_tags', silent = true}
            vim.keymap.nnoremap {
                '<leader>fm',
                with_cmd 'Telescope media_files media_files',
                silent = true
            }
            vim.keymap.nnoremap {'<leader>ft', with_cmd 'TodoTelescope', silent = true}
            vim.keymap.nnoremap {'<leader>op', with_cmd 'Telescope project project', silent = true}

            vim.keymap.nnoremap {
                '<leader>ob',
                with_cmd 'Telescope vim_bookmarks all',
                silent = true
            }
        end,
        disable = not nocode()
    }

    use {
        'hrsh7th/nvim-compe',
        requires = {'windwp/nvim-autopairs', 'L3MON4D3/Luasnip', 'rafamadriz/friendly-snippets'},
        config = function()
            local vim = vim
            local autopairs = require('nvim-autopairs')
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
                    luasnip = true,
                    treesitter = true,
                    tabnine = true
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

            local luasnip = require('luasnip')
            luasnip.config.set_config({
                history = true,
                -- Update more often, :h events for more info.
                updateevents = "TextChanged,TextChangedI"
            })
            require('up-config.snippets')
            require("luasnip/loaders/from_vscode").load()
            -- Use (s-)tab to:
            --- move to prev/next item in completion menuone
            --- jump to prev/next snippet's placeholder
            _G.tab_complete = function()
                if vim.fn.pumvisible() == 1 then
                    return t "<C-n>"
                    -- elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() ==
                    -- 1 then
                    -- return t "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"
                    -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
                    --     return t "<Plug>(vsnip-expand-or-jump)"
                elseif luasnip and luasnip.expand_or_jumpable() then
                    return t "<Plug>luasnip-expand-or-jump"
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
                    -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
                    --     return t "<Plug>(vsnip-jump-prev)"
                elseif luasnip and luasnip.jumpable(-1) then
                    return t "<Plug>luasnip-jump-prev"
                else
                    return t "<S-Tab>"
                end
            end

            vim.keymap.imap {"<Tab>", "v:lua.tab_complete()", expr = true}
            vim.keymap.smap {"<Tab>", "v:lua.tab_complete()", expr = true}
            vim.keymap.imap {"<S-Tab>", "v:lua.s_tab_complete()", expr = true}
            vim.keymap.smap {"<S-Tab>", "v:lua.s_tab_complete()", expr = true}

            vim.g.user_emmet_install_global = 0
            vim.g.user_emmet_install_command = 0
            vim.g.user_emmet_mode = 'i'
            vim.g.user_emmet_leader_key = '<C-Z>'

            vim.g.completion_confirm_key = ""
            Mlem.completion_confirm = function()
                if vim.fn.pumvisible() == 1 then
                    if vim.fn.complete_info()["selected"] ~= -1 then
                        return vim.fn["compe#confirm"](autopairs.esc("<cr>"))
                    else
                        return autopairs.esc("<cr>")
                    end
                else
                    return autopairs.autopairs_cr()
                end
            end

            vim.keymap.inoremap {'<C-Space>', "compe#complete()", expr = true}
            vim.keymap.inoremap {'<CR>', "v:lua.Mlem.completion_confirm()", expr = true}
            vim.keymap.inoremap {'<C-e>', "compe#close('<C-e>')", expr = true}
            -- vim.keymap.inoremap {'<C-f>', "compe#scroll({ 'delta': +4 })", expr = true}
            -- vim.keymap.inoremap {'<C-d>', "compe#scroll({ 'delta': -4 })", expr = true}

            vim.g.UltiSnipsExpandTrigger = "<C-j>"
            -- g.UltiSnipsJumpForwardTrigger = "<C-j>"
            -- g.UltiSnipsJumpBackwardTrigger = "<C-k>"

            vim.keymap.nmap {"<Leader>V", "UltiSnipsEdit", silent = true}
        end,
        disable = not nocode()
    }
    use {
        'tzachar/compe-tabnine',
        run = './install.sh',
        requires = 'hrsh7th/nvim-compe',
        disable = not nocode()
    }
    use {
        'tpope/vim-obsession',
        setup = function()
            local vim = vim
            vim.g.prosession_on_startup = 1
            vim.g.auto_session_pre_save_cmds = {"tabdo NvimTreeClose"}

            -- TODO: add Obsession optims

            local sessionsDir = Mlem.paths.session

            local e = vim.fn.fnameescape

            local function getSessionName()
                local cwd = vim.fn.getcwd()
                return cwd:gsub("/", "%%")
            end

            local function getSessionFile()
                return sessionsDir .. getSessionName() .. ".vim"
            end

            local function getLastSessionFile()
                local last = io.popen("/bin/ls -t " .. sessionsDir .. "| head -n1")
                return sessionsDir .. last:read()
            end

            local function loadSession(sessionFile)
                if sessionFile and vim.fn.filereadable(sessionFile) ~= 0 then
                    vim.cmd("source " .. e(sessionFile))
                end
                vim.cmd("silent Obsession " .. e(sessionFile))
            end

            local M = {}

            M.start = function()
                local sessionFile = getSessionFile()
                vim.cmd("Obsession " .. e(sessionFile))
            end

            M.stop = function() vim.cmd("Obsession!") end

            M.load = function(opt)
                if type(opt) == "string" then
                    return loadSession(opt)
                elseif type(opt) == "table" then
                    if opt.file then return loadSession(opt.file) end
                    if opt.last then return loadSession(getLastSessionFile()) end
                end
                return loadSession(getSessionFile())
            end

            M.list = function() return vim.fn.glob(sessionsDir .. "*.vim", true, true) end
            Mlem.session = M
            vim.cmd([[au BufReadPre * ++once lua Mlem.session.start()]])
        end,
        config = function()
            vim.keymap.nnoremap {'<leader>sl', function() _G.Mlem.session.load({}) end}
            vim.keymap.nnoremap {
                '<leader>sL',
                function() _G.Mlem.session.load({last = true}) end,
                as_command = 'LoadLastSession'
            }
            vim.keymap.nnoremap {'<leader>sd', function() _G.Mlem.session.stop() end}
        end,
        disable = not nocode()
    }
end)
