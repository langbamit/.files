local vim = vim
local M = {}


local create_missing_dirs = function()
    local home = os.getenv('HOME')
    local sep = package.config:sub(1, 1)

    local join = function(segments) return table.concat(segments, sep) end

    local cache_path = join {home, '.cache', 'nvim'}
    local session_path = join {cache_path, 'session'}
    local spell_path = join {cache_path, 'spell'}
    local undo_path = join {home, '.undodir'}

    local paths = {session = session_path, spell = spell_path, undo = undo_path}

    for _, p in pairs(paths) do if vim.fn.isdirectory(p) == 0 then os.execute('mkdir -p ' .. p) end end
    paths.home = home
    paths.sep = sep
    paths.join = join
    M.paths = paths
end
create_missing_dirs()
M.banner = {
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
function M.log(msg, hl, name)
  name = name or "Neovim"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  M.log(msg, "LspDiagnosticsDefaultWarning", name)
end

function M.error(msg, name)
  M.log(msg, "LspDiagnosticsDefaultError", name)
end

function M.info(msg, name)
  M.log(msg, "LspDiagnosticsDefaultInformation", name)
end

function M.toggle(option, silent)
  local info = vim.api.nvim_get_option_info(option)
  local scopes = { buf = "bo", win = "wo", global = "o" }
  local scope = scopes[info.scope]
  local options = vim[scope]
  options[option] = not options[option]
  if silent ~= true then
    if options[option] then
      M.info("enabled vim." .. scope .. "." .. option, "Toggle")
    else
      M.warn("disabled vim." .. scope .. "." .. option, "Toggle")
    end
  end
end

function M.float_terminal(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local vpad = 4
  local hpad = 10
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns - hpad * 2,
    height = vim.o.lines - vpad * 2,
    row = vpad,
    col = hpad,
    style = "minimal",
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  })
  vim.fn.termopen(cmd)
  local autocmd = {
    "autocmd! TermClose <buffer> lua",
    string.format("vim.api.nvim_win_close(%d, {force = true});", win),
    string.format("vim.api.nvim_buf_delete(%d, {force = true});", buf),
  }
  vim.cmd(table.concat(autocmd, " "))
  vim.cmd([[startinsert]])
end

_G.Mlem = M
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
function _G.with_cmd(rhs) return '<cmd>' .. rhs .. '<cr>' end

