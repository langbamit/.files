local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/savq/paq-nvim.git', install_path})
end
execute 'packadd paq-nvim'

require("keymap")
require('globals-setup')
require('general-setup')

require('plugins-setup')

require('smartquit')

