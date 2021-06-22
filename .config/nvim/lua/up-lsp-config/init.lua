local vim = vim
return function()
    local lsp = require('lspconfig')
    local illuminate = require('illuminate') -- Automatically highlight other user of current word under the cursor
    local aerial = require 'aerial' -- Code folding and navegation
    local saga = require 'lspsaga'

    saga.init_lsp_saga()
    local on_attach = function(client, bufnr)
        local buf_map = function(opts, mode)
            mode = mode or 'n'
            vim.keymap[mode .. 'noremap'](vim.tbl_extend("force", opts,
                                                         {silent = true, buffer = bufnr}))
        end
        -- SignatureHelp
        require('lsp_signature').on_attach {
            bind = true,
            hint_prefix = "",
            handler_opts = {border = "single"}
        }

        illuminate.on_attach(client)

        -- vim.api.nvim_command [[ hi! link LspReferenceText CursorLine ]]
        -- vim.api.nvim_command [[ hi! link LspReferenceWrite CursorLine ]]
        -- vim.api.nvim_command [[ hi! link LspReferenceRead CursorLine ]]
        -- vim.api.nvim_command 'hi CursorLine ctermbg=NONE guibg=NONE cterm=underline gui=underline'

        --- GOTO Mappings
        buf_map {'gd', function() vim.lsp.buf.definition() end, as_command = 'LspDefination'}
        buf_map {'gD', function() vim.lsp.buf.declaration() end, as_command = 'LspDeclaration'}
        buf_map {
            'gs',
            function() vim.lsp.buf.document_symbol() end,
            as_command = 'LspDocumentSymbol'
        }
        buf_map {'ga', function() vim.lsp.buf.code_action() end, as_command = 'LspCodeAction'}
        buf_map {'<leader>rn', function() vim.lsp.buf.rename() end, as_command = 'LspRename'}
        buf_map {'<leader>F', function() vim.lsp.buf.formatting() end, as_command = 'LspFormatting'}

        buf_map {'<C-Space>', function() vim.lsp.buf.hover() end, as_command = 'LspHover'}

        --- diagnostics navegation mappings
        buf_map {
            'gE',
            function() vim.lsp.diagnostic.goto_prev() end,
            as_command = 'LspDiagnosticGotoPrev'
        }
        buf_map {
            'ge',
            function() vim.lsp.diagnostic.goto_next() end,
            as_command = 'LspDiagnosticGotoNext'
        }
        buf_map {'<C-Space>', function() vim.lsp.buf.hover() end, as_command = 'LspHover'}

        
        --- Code folding & Navigation
        aerial.on_attach(client)

        -- Aerial does not set any mappings by default, so you'll want to set some up
        -- Toggle the aerial window with <leader>a
    
        buf_map {'<leader>a', '<cmd>AerialToggle! right<CR>'}
        -- Jump forwards/backwards with '{' and '}'
        buf_map {'{', '<cmd>AerialPrev<CR>'}
        buf_map {'}', '<cmd>AerialNext<CR>'}
        -- Jump up the tree with '[[' or ']]'
        buf_map {'[[', '<cmd>AerialPrevUp<CR>'}
        buf_map {']]', '<cmd>AerialNextUp<CR>'}
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

    local function setup_rust_tools()
        require'rust-tools'.setup({
            autoSetHints = true,
            runnables = {use_telescope = true},
            inlay_hints = {show_parameter_hints = true},
            server = {
                cmd = {"rustup", "run", "nightly", "rust-analyzer"},
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            overrideCommand = {
                                Mlem.paths.join {
                                    Mlem.paths.home, "rustc_codegen_cranelift/build/cargo.sh"
                                }, "check", "--message-format=json"
                            }
                        }
                    }
                }
            }
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
    lsp.sumneko_lua.setup {cmd = {sumneko_binary}, on_attach = on_attach}

    -- vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                     {virtual_text = true, signs = true, update_in_insert = true})

    --- auto-commands
    -- cmd "au BufWritePre *.rs lua vim.lsp.buf.formatting_sync()"
    -- cmd "au CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()"

    --- lightbulb
    vim.fn.sign_define("LightBulbSign", {text = "💡", texthl = "LspDiagnosticsSignWarning"})

    vim.cmd [[ autocmd CursorHold,CursorHoldI * lua Mlem.LightBulbFunc()]]

    Mlem.LightBulbFunc = function()
        require("nvim-lightbulb").update_lightbulb({sign = {enabled = true}})
    end
    -- vim.cmd [[
    -- hi! CursorLine cterm=underline gui=underline
    -- hi! LspReferenceText cterm=underline gui=underline
    -- hi! LspReferenceWrite cterm=underline gui=underline
    -- hi! LspReferenceRead cterm=underline gui=underline
    -- ]]
    vim.g.Illuminate_ftblacklist = {'dashboard'}
    vim.keymap.nnoremap {'<A-n>', function() illuminate.next_reference {wrap = true} end}
    vim.keymap.nnoremap {
        '<A-S-n>', function() illuminate.next_reference {reverse = true, wrap = true} end
    }
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

    require('lsp-rooter').setup {}
    -- Don't use DraculaSelection highlight group, use CursorLine for document highlight
    vim.cmd [[
    augroup illuminate_group
        autocmd!
        autocmd VimEnter * hi CursorLine ctermbg=NONE guibg=NONE cterm=underline gui=underline
    augroup end
    hi! link LspReferenceText CursorLine
    hi! link LspReferenceWrite CursorLine
    hi! link LspReferenceRead CursorLine
 ]]
end
