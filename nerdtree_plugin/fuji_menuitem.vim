" ============================================================================
" File:        fuji_menuitem.vim
" Description: plugin for the NERD Tree that provides node open and grep(using
"              ripgrep)
" Maintainer:  Masaaki Fujiwara <lranran at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"
" ============================================================================
if exists("g:loaded_nerdtree_fuji_menuitem")
    finish
endif
let g:loaded_nerdtree_fuji_menuitem = 1

call NERDTreeAddMenuItem({'text': '(o)pen the current node with system editor', 'shortcut': 'o', 'callback': 'NERDTreeExecuteFileWin32'})
call NERDTreeAddMenuItem({'text': '(g)rep directory', 'shortcut': 'g', 'callback': 'NERDTreeGrepDirectory'})

" FUNCTION: NERDTreeExecuteFileWin32() {{{1
function! NERDTreeExecuteFileWin32()
    let treenode = g:NERDTreeFileNode.GetSelected()
    if treenode != {}
        let winpath = system("cygpath -w '" . treenode.path.str() . "'")
        call system("explorer '" . winpath . "'")
    endif
endfunction

" FUNCTION: NERDTreeGrepDirectory() {{{1
function! NERDTreeGrepDirectory()
    let dirnode = g:NERDTreeDirNode.GetSelected()
    let pattern = input("Enter the search pattern/options: ")

    if pattern == ''
        call nedtree#echo("Grep directory aborted.")
        return
    "else
    "    if match(pattern, '"') >= 0
    "        let pattern = substitute(pattern, '"', '\\"', 'g')
    "    endif
    "    let pattern = join(['"', pattern, '"'], '')
    endif

    wincmd w
    let old_shellpipe = &shellpipe
    let &shellpipe='&>'

    try
        let s:current_dir = expand("%:p:h")
        exec 'silent cd ' . dirnode.path.str()
        exec 'silent Rg ' . pattern .' .'
    finally
        let &shellpipe = old_shellpipe
        exec 'silent cd '. s:current_dir
    endtry

    let hits = len(getqflist())
    if hits == 0
        echo "No hits"
    elseif hits > 1
        copen
    endif
endfunction
" vim: set sw=4 sts=4 et fdm=marker:
