require('plugins-setup.before')
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
    'kyazdani42/nvim-tree.lua';
    'ahmedkhalf/lsp-rooter.nvim';
    'mg979/vim-visual-multi';
    'Shatur/neovim-session-manager';
    --- Git
    'lewis6991/gitsigns.nvim';
    'langbamit/git-blame.nvim';
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
    'windwp/nvim-ts-autotag';
    {'tzachar/compe-tabnine', run='./install.sh'};

    --- Snippets
    'hrsh7th/vim-vsnip';
    'hrsh7th/vim-vsnip-integ';

    --- Telescope
    'nvim-lua/popup.nvim';
    'nvim-telescope/telescope.nvim';
    'nvim-telescope/telescope-media-files.nvim';
    'nvim-telescope/telescope-project.nvim';
    {'nvim-telescope/telescope-fzy-native.nvim', run='git submodule update --init --recursive'};
    -- 'fhill2/telescope-ultisnips.nvim';

    -- Debugger
    'mfussenegger/nvim-dap';
    --- Misc
    'hoob3rt/lualine.nvim';
    'akinsho/nvim-bufferline.lua';
    'mbbill/undotree';
    'h-youhei/vim-ibus';
    -- 'Yggdroot/indentLine';
    {'lukas-reineke/indent-blankline.nvim', branch = 'lua'};
    'numToStr/Navigator.nvim';
    'folke/which-key.nvim';
})
-- LuaFormatter on
require('plugins-setup.after')
require('plugins-setup.treesitter-setup')
require('lsp-setup')
require('plugins-setup.completion-setup')
require('plugins-setup.telescope-setup')
