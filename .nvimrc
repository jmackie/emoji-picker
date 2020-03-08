map <C-b> :!cargo run<cr>

let g:ale_linters = {
\   'sh': ['shellcheck'],
\   'nix': ['nix'],
\   'rust': ['rls'],
\}

" https://github.com/w0rp/ale/blob/master/autoload/ale/fix/registry.vim
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'rust': ['rustfmt'],
\   'sh': ['shfmt'],
\   'toml': ['prettier'],
\   'markdown': ['prettier'],
\   'nix': ['Nixfmt'],
\}

function! Nixfmt(buffer) abort
    return { 'command': 'nixfmt' }
endfunction
