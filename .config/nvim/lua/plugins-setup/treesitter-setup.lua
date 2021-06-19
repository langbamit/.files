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
