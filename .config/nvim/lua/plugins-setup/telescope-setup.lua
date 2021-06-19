local vim = vim
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
        media_files = {file_types = {"png", "jpg", "mp4", "webm", "pdf"}, find_cmd = "rg"},
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
vim.keymap.nnoremap {'<leader>fm', with_cmd 'Telescope media_files media_files', silent = true}
vim.keymap.nnoremap {'<leader>fp', with_cmd 'Telescope project project', silent = true}
vim.keymap.nnoremap {'<leader>fc', with_cmd 'TodoTelescope', silent = true}
