local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

local server_name = 'svelte'
local bin_name = 'svelteserver'


configs[server_name] = {
default_config = {
    cmd = {bin_name, '--stdio'};
    filetypes = {'svelte'};
    root_dir = util.root_pattern('svelte.config.js', '.git')
};
docs = {
    description = [[
```sh
    npm install -g svelte-language-server
```
    ]];
    default_config = {
        root_dir = [[root_pattern('svelte.config.js')]]
    }
}

}
