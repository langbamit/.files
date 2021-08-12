eval %sh{kak-lsp --kakoune -s $kak_session}

set global lsp_hover_anchor true
map global user "l" ": fail Filetype don't support lsp<ret>" -docstring "LSP mode (Unsupport Filetype)"

def lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }

def -hidden lsp-init -docstring "enable lsp and set up generic hooks" %{
    echo -debug "Enabling LSP for filetype %opt{filetype}"
    map window user "l" ": enter-user-mode lsp<ret>" -docstring "LSP mode"
    set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
    lsp-enable-window

    set window lsp_auto_highlight_references true

    # Enable inlay and inline diagnostics in normal mode, but disable in insert mode
    lsp-inlay-diagnostics-enable window
    hook window ModeChange push:.*:insert %{
        lsp-inlay-diagnostics-disable window
        lsp-inline-diagnostics-disable window
    }
    hook window ModeChange pop:insert:.* %{
        lsp-inlay-diagnostics-enable window
        lsp-inline-diagnostics-enable window
    }

    # Function signature help in status bar
    lsp-auto-signature-help-enable

    # Experimental insert mode auto-hover
    lsp-auto-hover-insert-mode-enable

    # Semantic tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        rmhooks window semantic-tokens
    }
}
hook global KakEnd .* lsp-exit
