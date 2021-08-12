hook global WinSetOption filetype=rust %{
    lsp-init
    hook window BufWritePre .* lsp-formatting-sync
    set buffer formatcmd "rustfmt"

    set-option -add global lsp_server_configuration rust.clippy_preference="on"

    hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
    hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window rust-inlay-hints
    }

    # Remove ', not useful in rust lifetime 
    set window auto_pairs ( ) { } [ ] '"' '"' ` ` “ ” ‘ ’ « » ‹ ›
}
