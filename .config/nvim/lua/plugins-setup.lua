local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd("packadd packer.nvim")

local packer = require('packer')

packer.init({git = {clone_timeout = 350}})

packer.startup(function(use)
    use {'wbthomason/packer.nvim', opt = true} -- Manager itself to avoid clean

    use {'dracula/vim', as = 'dracula', config = function() vim.cmd 'colorscheme dracula' end}
    use {'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup({}) end}
    use {'tpope/vim-repeat'}
    use {'tpope/vim-surround'}

    use {'mattn/emmet-vim'}
    -- use {'tzachar/compe-tabnine', run = './install.sh', after = 'nvim-compe'}

    --- Snippets
    use {'hrsh7th/vim-vsnip-integ', requires = 'hrsh7th/vim-vsnip'}

    use {
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup {check_ts = true} end
    }

    -- Debugger
    use {'mfussenegger/nvim-dap'}
    -- https://github.com/mg979/vim-visual-multi
    use {'mg979/vim-visual-multi'}

    -- https://github.com/ahmedkhalf/lsp-rooter.nvim
    use {'ahmedkhalf/lsp-rooter.nvim', config = function() require('lsp-rooter').setup {} end}
    -- https://github.com/karb94/neoscroll.nvim
    use {'karb94/neoscroll.nvim', config = function() require('neoscroll').setup() end}
    --- Git
    -- https://github.com/lewis6991/gitsigns.nvim
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }
    -- https://github.com/
    use {
        'langbamit/git-blame.nvim',
        setup = function() vim.g.gitblame_virtual_text = 0 end,
        event = 'VimEnter'
    }
    -- https://github.com/mbbill/undotree
    use {
        'mbbill/undotree',
        config = function() vim.keymap.nnoremap {'<M-u>', with_cmd "UndotreeToggle"} end
    }
    -- https://github.com/h-youhei/vim-ibus
    use {
        'h-youhei/vim-ibus',
        config = function()
            vim.g['ibus#layout'] = 'xkb:us::eng'
            vim.g['ibus#engine'] = 'Bamboo'
        end
    }
    -- https://github.com/kevinhwang91/rnvimr
    use {
        'kevinhwang91/rnvimr',
        config = function() -- g.rnvimr_enable_ex = 1
            -- g.rnvimr_enable_bw = 1
            vim.keymap.nnoremap {'<M-o>', with_cmd 'RnvimrToggle', silent = true}
        end
    }
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    use {
        'lukas-reineke/indent-blankline.nvim',
        branch = 'lua',
        config = function()
            vim.g.indent_blankline_char = '┊'
            vim.g.indent_blankline_filetype_exclude = {'dashboard'}
        end
    }
    use {
        'terrortylor/nvim-comment',
        config = function()
            require('nvim_comment').setup {
                -- line_mapping = " cl",
                -- operator_mapping = " c"
            }
        end
    } --- LSP & language support
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'onsails/lspkind-nvim', 'kosayoda/nvim-lightbulb', 'ray-x/lsp_signature.nvim',
            'RRethy/vim-illuminate', 'simrat39/rust-tools.nvim', 'RishabhRD/popfix',
            'RishabhRD/nvim-lsputils', 'stevearc/aerial.nvim', 'glepnir/lspsaga.nvim'
        },
        config = function() require('up-lsp-config')() end
    }

    -- https://github.com/hoob3rt/lualine.nvim
    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true},
        config = function()
            local location = function() return '(Ln %l/%L, Col %c)' end

            require('lualine').setup {
                options = {theme = 'dracula', section_separators = '', component_separators = ''},
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
        end
    }
    -- https://github.com/akinsho/nvim-bufferline.lua
    use {
        'akinsho/nvim-bufferline.lua',
        config = function()
            require"bufferline".setup {
                options = {
                    separator_style = {'', ''},
                    tab_size = 22,
                    enforce_regular_tabs = true,
                    view = "multiwindow",
                    show_buffer_close_icons = true
                }
            }
        end
    }

    -- https://github.com/numToStr/Navigator.nvim
    use {
        'numToStr/Navigator.nvim',
        config = function()
            require('Navigator').setup()
            vim.keymap.nnoremap {'<m-h>', with_cmd "lua require('Navigator').left()", silent = true}
            vim.keymap.nnoremap {'<m-j>', with_cmd "lua require('Navigator').down()", silent = true}
            vim.keymap.nnoremap {'<m-k>', with_cmd "lua require('Navigator').up()", silent = true}
            vim.keymap.nnoremap {
                '<m-l>',
                with_cmd "lua require('Navigator').right()",
                silent = true
            }
        end
    }
    use {
        'folke/todo-comments.nvim',
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require'todo-comments'.setup {
                highlight = {keyword = "bg"},
                colors = {
                    error = {"LspDiagnosticsDefaultError", "ErrorMsg", "#ff5555"},
                    warning = {"LspDiagnosticsDefaultWarning", "WarningMsg", "#ffb86c"},
                    info = {"LspDiagnosticsDefaultInformation", "#8be9fd"},
                    hint = {"LspDiagnosticsDefaultHint", "#50fa7b"},
                    default = {"Identifier", "#bd93f9"}
                }
            }
        end
    }

    use {
        'windwp/nvim-spectre',
        requires = {"nvim-lua/plenary.nvim", 'nvim-lua/popup.nvim'},
        config = function()
            require('spectre').setup {}

            vim.keymap.nnoremap {
                '<leader>t',
                with_cmd "lua require('spectre').open()",
                silent = true
            }
            -- search current word
            -- keymap.nnoremap { "<leader>srw", "viw:lua require('spectre').open_visual()<CR>" }
            -- keymap.vnoremap { "<leader>s", with_cmd "lua require('spectre').open_visual()" }

            -- search in current file
            -- keymap.nnoremap  <leader>sp viw:lua require('spectre').open_file_search()<cr>
        end
    }
    use {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        setup = function()
            vim.g.dashboard_default_executive = 'telescope'
            vim.g.dashboard_session_directory = Mlem.paths.session
            vim.g.dashboard_custom_header = Mlem.banner
            vim.g.dashboard_custom_footer = {
                '', '', '', '', '', '', '', 'https://github.com/langbamit'
            }
            vim.g.dashboard_custom_section = {
                a = {description = {'  Find File          '}, command = 'Telescope find_files'},
                b = {description = {'  Recently Used Files'}, command = 'Telescope oldfiles'},
                c = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
                d = {description = {'  Find Word          '}, command = 'Telescope live_grep'}
                -- e = {description = {'  Settings           '}, command = ':e '..CONFIG_PATH..'/lv-settings.lua'}
            }
        end,
        config = function()
            vim.keymap.nnoremap {'<leader>ss', with_cmd 'SessionSave'}
            vim.keymap.nnoremap {'<leader>sl', with_cmd 'SessionLoad'}

            vim.cmd [[ autocmd FileType dashboard setlocal showtabline=0 laststatus=0 nowrap | autocmd BufLeave <buffer> set showtabline=2 laststatus=2 ]]

        end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        event = 'VimEnter',
        setup = function()
            vim.g.nvim_tree_width = 40
            vim.g.nvim_tree_follow = 1
            vim.g.nvim_tree_hide_dotfiles = 0
            vim.g.nvim_tree_indent_markers = 1
            vim.g.nvim_tree_hijack_netrw = 1
            vim.g.nvim_tree_auto_open = 1
            vim.g.nvim_tree_auto_close = 0
            vim.g.nvim_tree_disable_netrw = 0
            vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
            vim.g.nvim_tree_lsp_diagnostics = 1
        end,
        config = function()
            vim.keymap.nnoremap {'<leader>e', with_cmd "NvimTreeToggle", silent = true}
        end
    }

    -- https://github.com/folke/which-key.nvim
    use {
        'folke/which-key.nvim',
        config = function()
            require("which-key").setup {
                plugins = {
                    marks = true, -- shows a list of your marks on ' and `
                    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                    -- No actual key bindings are created
                    presets = {
                        operators = false, -- adds help for operators like d, y, ...
                        motions = false, -- adds help for motions
                        text_objects = false, -- help for text objects triggered after entering an operator
                        windows = true, -- default bindings on <c-w>
                        nav = true, -- misc bindings to work with windows
                        z = true, -- bindings for folds, spelling and others prefixed with z
                        g = true -- bindings for prefixed with g
                    }
                },
                icons = {
                    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                    separator = "➜", -- symbol used between a key and it's label
                    group = "+" -- symbol prepended to a group
                },
                window = {
                    border = "single", -- none, single, double, shadow
                    position = "bottom", -- bottom, top
                    margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
                    padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
                },
                layout = {
                    height = {min = 4, max = 25}, -- min and max height of the columns
                    width = {min = 20, max = 50}, -- min and max width of the columns
                    spacing = 3 -- spacing between columns
                },
                hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
                show_help = true -- show help message on the command line when the popup is visible
            }

        end
    }
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

        end
    }
    -- https://github.com/
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = "nvim-treesitter/nvim-treesitter"
    }
    use {'nvim-treesitter/playground', requires = "nvim-treesitter/nvim-treesitter"}
    use {'RRethy/nvim-treesitter-textsubjects', requires = "nvim-treesitter/nvim-treesitter"}
    use {
        'JoosepAlviste/nvim-ts-context-commentstring',
        requires = "nvim-treesitter/nvim-treesitter"
    }
    use {'windwp/nvim-ts-autotag', requires = "nvim-treesitter/nvim-treesitter"}

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim',
            {
                'nvim-telescope/telescope-fzy-native.nvim',
                run = 'git submodule update --init --recursive'
            }, 'nvim-telescope/telescope-project.nvim', 'nvim-telescope/telescope-media-files.nvim'
        },
        config = function()
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
                    },
                    fzy_native = {override_generic_sorter = false, override_file_sorter = true}
                }
            }
            telescope.load_extension('media_files')
            telescope.load_extension('fzy_native')
            telescope.load_extension('project')

            vim.keymap.nnoremap {'<leader>ff', with_cmd 'Telescope find_files', silent = true}
            vim.keymap.nnoremap {'<leader>fo', with_cmd 'Telescope oldfiles', silent = true}
            vim.keymap.nnoremap {'<leader>fg', with_cmd 'Telescope live_grep', silent = true}
            vim.keymap.nnoremap {'<leader>fb', with_cmd 'Telescope buffers', silent = true}
            vim.keymap.nnoremap {'<leader>fh', with_cmd 'Telescope help_tags', silent = true}
            vim.keymap.nnoremap {
                '<leader>fm',
                with_cmd 'Telescope media_files media_files',
                silent = true
            }
            vim.keymap.nnoremap {'<leader>fp', with_cmd 'Telescope project project', silent = true}
            vim.keymap.nnoremap {'<leader>fc', with_cmd 'TodoTelescope', silent = true}
        end
    }

    use {
        'hrsh7th/nvim-compe',
        requires = 'windwp/nvim-autopairs',
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
                    ultisnips = true,
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

            vim.g.user_emmet_install_global = 0
            vim.g.user_emmet_install_command = 0
            vim.g.user_emmet_mode = 'i'

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
        end
    }
end)