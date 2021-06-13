local globals = {}

local create_missing_dirs = function()
    local home = os.getenv('HOME')
    local sep = package.config:sub(1, 1)

    local join = function(segments) return table.concat(segments, sep) end

    local cache_path = join {home, '.cache', 'nvim'}
    local session_path = join {cache_path, 'session'}
    local spell_path = join {cache_path, 'spell'}
    local undo_path = join {home, '.undodir'}
    globals.home = home
    globals.path_sep = sep

    local paths = {session = session_path, spell = spell_path, undo = undo_path}

    for _, p in pairs(paths) do if vim.fn.isdirectory(p) == 0 then os.execute('mkdir -p ' .. p) end end
    globals.paths = paths
end
create_missing_dirs()

globals.banner = {
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

_G.Mlem = globals
