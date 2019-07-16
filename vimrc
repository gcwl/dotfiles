" Note about control characters
" In order to add a control character to your .vimrc you must type Ctrl-v
" first. For example,  is done by Ctrl-v Ctrl-t.


" self help
" :help <topic>
" e.g.
" :help linebreak

" run from shell
" $ vimtutor


" Online Sources
" --------------
" [Vim Commands Cheat Sheet](http://bullium.com/support/vim_print.html)
" [vimtips](http://www-tips.org/tips)
" [Best Vim Tips](http://vim.wikia.com/wiki/Best_Vim_Tips)
" https://wiki.archlinux.org/index.php/Vimrc


" Vim Scripting
" -------------
" https://stackoverflow.com/questions/2153892/good-guide-on-vim-scripting
" http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html
" http://learnvimscriptthehardway.stevelosh.com/
" :help function-list



" =============================================================
" General
" =============================================================


" enable mouse for all modes
set mouse=a


" enable filetype plugin
" ----------------------
filetype plugin on
filetype indent on


" Global omnicomplete
" -------------------
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,preview,noinsert
inoremap <silent>  <C-x><C-o>


let mapleader=','


set ffs=unix,dos,mac           " Default file types
set history=1024               " how many lines of history to remember
set nocompatible               " use Vim settings, rather then Vi settings (much better!).


set autoread                   " Set to auto read when a file is changed from the outside
set showmatch                  " when a bracket is inserted, briefly jump to the matching one
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set selectmode=mouse           " select when using the mouse
set laststatus=2               " Always display a status line at the bottom of the window
set shortmess=a                " always show 'short messages'
set scrolloff=7                " set 7 lines to the curors - when moving vertical
"set confirm                    " Confirm quit (:q) or delete (:bd) when changes are made
set hidden                     " :help hidden
                               " XXX WARN XXX: It's easy to forget that you have changes in hidden buffers.
                               " Think twice when using ":q!" or ":qa!".
set t_Co=256                   " 256 color


" dont want no Ex mode
nmap Q <Nop>


" default encoding and language
" -----------------------------
set encoding=utf8
try
    lang en_US
catch
endtry


" layout
" ------
set number              " show line numbers
set ruler               " always show current position
set wildmenu
set cmdheight=2         " commandbar height


" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
" Remember info about open buffers on close
set viminfo^=%


" folding
" -------
" http://vim.wikia.com/wiki/Folding
" common folding actions: zr, zR, zm, zM, za, zA
set foldmethod=indent
" If you like the convenience of having Vim define folds automatically by
" indent level, but would also like to create folds manually, you can get both
" by putting this in your vimrc:
"augroup vimrc
"  au BufReadPre * setlocal foldmethod=indent
"  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
"augroup END
set foldnestmax=10      " deepest fold is 10 levels
set nofoldenable        " dont fold by default
"set foldlevel=99
" In normal mode, press Space to toggle the current fold open/closed. However,
" if the cursor is not in a fold, move to the right (the default behavior). In
" addition, with the manual fold method, you can create a fold by visually
" selecting some lines, then pressing Space.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf


" backup files
" ------------
set nobackup            " do not keep a backup files
set nowritebackup


" search
" ------
set hlsearch            " highlight search
set ignorecase          " ignore case when searching
set infercase
set smartcase           " :help smartcase
set incsearch           " do incremental searches (annoying but handy)


" soft wrap
" ---------
set wrap linebreak nolist   " list disables linebreak
"set wrap linebreak textwidth=0

"set autoindent " always  set auto indenting on
"set verbose=9 " turn on the verboseness to see everything vim is doing.
"set gdefault     " g flag always on

" command to unset autoindent
":setlocal noautoindent nocindent nosmartindent indentexpr=
":setl noai nocin nosi inde=



" =============================================================
" Vim Plugins
" =============================================================
"
" pathogen
" --------
" https://github.com/tpope/vim-pathogen
execute pathogen#infect()
"
" colorscheme
" ------------
" https://code.google.com/p/vimcolorschemetest/
syntax on
set background=dark
colorscheme 256-jungle
" colorscheme xoria256
" colorscheme busybee
" colorscheme gentooish
" colorscheme molokai
" colorscheme crt
" colorscheme cthulhian
" colorscheme desert256
"
" if has('nvim')
"   colorscheme molokai
" else
"   colorscheme busybee
" endif
"
" Airline
" -------
" https://github.com/bling/vim-airline
" https://github.com/bling/vim-airline.git
" :help airline
let g:airline_theme='laederon'
"let g:airline_theme='lucius'
let g:airline_detect_spell = 1
" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#enabled = 0
" https://vi.stackexchange.com/questions/3359/how-to-fix-status-bar-symbols-in-airline-plugin
" let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
" let g:airline_symbols.crypt = '🔒'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
" let g:airline_symbols.spell = 'Ꞩ'
" let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" help :statusline for full list of format
"
" General format of statusline item looks like:
" %-0{minwidth}.{maxwidth}{item}
" everything except the % and the {item} is optional, where - is left align, 0 is zeropad
"
" airline section C = [(cwd)] (filename)(modifier[+])(readonly[RO])
" let g:airline_section_c = '[%-.30{getcwd()}] %t%m%r'
" let g:airline_section_c = '%-.40F%m%r'
function s:ShortPath(path, maxlength)
  let path = substitute(a:path, "^".$HOME, "~", "")
  if strlen(path) <= a:maxlength
    return path
  endif
  let s = split(path, '/')
  let h = []
  for t in s[:-2]
    call add(h, t[0] == '.' ? t[:1] : t[:0])
  endfor
  call add(h, s[-1])
  return join(h, '/')
endfunction
"
function g:ShortCwd(maxlength)
  return s:ShortPath(getcwd(), a:maxlength)
endfunction
"
function g:ShortFilePath(maxlength)
  if getcwd() == expand('%:p:h')
    return expand('%:t')
  else
    return s:ShortPath(@%, a:maxlength)
  endif
endfunction
"
let g:airline_section_c = '[%-.30{ShortCwd(30)}] %-.30{ShortFilePath(30)}%m%r'



"
" ctrlp.vim
" ---------
" https://kien.github.io/ctrlp.vim/
" https://github.com/kien/ctrlp.vim.git
" :help ctrlp-commands
" :help ctrlp-extensions
"
" > In popup windown:
" <F5>                       | purge the cache for the current directory to get new files, remove deleted files and apply new ignore options
" <c-f> and <c-b>            | cycle between modes
" <c-d>                      | switch to filename only search instead of full path
" <c-r>                      | switch to regexp mode
" <c-j>, <c-k> or arrow keys | navigate the result list
" <c-t> or <c-v>, <c-x>      | open the selected entry in a new tab or in a new split
" <c-n>, <c-p>               | select the next/previous string in the prompt's history
" <c-y>                      | create a new file and its parent directories
" <c-z>                      | mark/unmark multiple files and <c-o> to open them
let g:ctrlp_map = '<leader><Space>'
" Run :CtrlP or :CtrlP [starting-directory] to invoke CtrlP in find file mode.
" Run :CtrlPBuffer or :CtrlPMRU to invoke CtrlP in find buffer or find MRU file mode.
" Run :CtrlPMixed to search in Files, Buffers and MRU files at the same time.
let g:ctrlp_cmd = 'CtrlPMixed'
"
" " Gundo
" " -----
" " http://sjl.bitbucket.org/gundo.vim/
" " https://github.com/sjl/gundo.vim.git
" " https://github.com/vim-scripts/Gundo
" " http://www.bestofvim.com/plugin/gundo/
" " related   :help undo-tree
" "           :help undo-branches
" nnoremap <F2> <Esc>:GundoToggle<CR>
"
" nerdtree
" --------
" https://github.com/scrooloose/nerdtree
" https://github.com/scrooloose/nerdtree.git
" http://www.bestofvim.com/plugin/nerdtree/
nnoremap <F4> <Esc>:NERDTreeToggle<CR>
"
" EasyAlign
" ---------
" https://github.com/junegunn/vim-easy-align
vmap \ <Plug>(LiveEasyAlign)
" In live interactive mode, you have to type in the same delimiter (or
" <CTRL-X> on regular expression) again to finalize the alignment. This allows
" you to preview the result of the alignment and freely change the delimiter
" using backspace key without leaving the interactive mode.
"
" visual map        | Description                        | Equivalent command
" ----------        | -----------                        | ------------------
" <Enter><Space>    | Around 1st whitespaces             | :'<,'>EasyAlign\
" <Enter>2<Space>   | Around 2nd whitespaces             | :'<,'>EasyAlign2\
" <Enter>-<Space>   | Around the last whitespaces        | :'<,'>EasyAlign-\
" <Enter>-2<Space>  | Around the 2nd to last whitespaces | :'<,'>EasyAlign-2\
" <Enter>:          | Around 1st colon (key: value)      | :'<,'>EasyAlign:
" <Enter><Right>:   | Around 1st colon (key : value)     | :'<,'>EasyAlign:<l1
" <Enter>=          | Around 1st operators with =        | :'<,'>EasyAlign=
" <Enter>3=         | Around 3rd operators with =        | :'<,'>EasyAlign3=
" <Enter>*=         | Around all operators with =        | :'<,'>EasyAlign*=
" <Enter>**=        | Left-right alternating around =    | :'<,'>EasyAlign**=
" <Enter><Enter>=   | Right alignment around 1st =       | :'<,'>EasyAlign!=
" <Enter><Enter>**= | Right-left alternating around =    | :'<,'>EasyAlign!**=
"
" vim-signature
" -------------
" https://github.com/kshenoy/vim-signature
" https://github.com/kshenoy/vim-signature.git
" Plugin to toggle, display and navigate marks
" see ~/.vim/bundle/vim-signature/doc/signature.txt for this default map
let g:SignatureMap = { 'ToggleMarkAtLine' : "mm", 'PurgeMarks' : "m<BS>" }

" vim marks jump
" sequence | description
" -------- | -----------
" '.       | jump to line where last change occurred in current buffer
" '"       | jump to line where last exited current buffer
" ''       | jump back (to line in current buffer where jumped from)

" supertab
" --------
" https://github.com/ervandew/supertab
" https://github.com/ervandew/supertab.git
" Perform all your vim insert mode completions with Tab
"
" syntastic
" ---------
" https://github.com/scrooloose/syntastic
" https://github.com/scrooloose/syntastic.git
" Syntax checking hacks for vim
"
" vim-markdown
" ------------
" https://github.com/plasticboy/vim-markdown
" https://github.com/plasticboy/vim-markdown.git
let g:vim_markdown_folding_disabled=1
"
" " vim-clang-format        XXX install latest clang to make this work
" " ----------------
" " https://github.com/rhysd/vim-clang-format
" let g:clang_format#detect_style_file = 0
" let g:clang_format#style_options = { 'BasedOnStyle' : 'Mozilla' }
"
" vim-commentary
" --------------
" keymapped to Ctrl-/
noremap  :Commentary<CR>
"
" fzf.vim
" -------
" https://github.com/junegunn/fzf.vim
" keymapped to <F4>
let g:fzf_action = {'ctrl-b': 'split', 'ctrl-v': 'vsplit'}
" ag grep with different depths
command! -nargs=* Grep call fzf#vim#ag(<q-args>, '--hidden -ftS', fzf#vim#with_preview('right:40%', '?'))
command! -nargs=* Grep1 call fzf#vim#ag(<q-args>, '--depth 1 --hidden -ftS', fzf#vim#with_preview('right:40%', '?'))
command! -nargs=* Grep2 call fzf#vim#ag(<q-args>, '--depth 2 --hidden -ftS', fzf#vim#with_preview('right:40%', '?'))
command! -nargs=* Grep3 call fzf#vim#ag(<q-args>, '--depth 3 --hidden -ftS', fzf#vim#with_preview('right:40%', '?'))
command! -nargs=* Grep6 call fzf#vim#ag(<q-args>, '--depth 6 --hidden -ftS', fzf#vim#with_preview('right:40%', '?'))
command! -nargs=* Grep9 call fzf#vim#ag(<q-args>, '--depth 9 --hidden -ftS', fzf#vim#with_preview('right:40%', '?'))
" git grep
command! -nargs=* GitGrep
  \ call fzf#vim#grep('git grep -niI --no-color ' . shellescape(<q-args>) . ' -- $(git rev-parse --show-toplevel)',
    \ 0, fzf#vim#with_preview('right:40%', '?'))
" fzf keymaps
nnoremap <C-f>           :execute "Lines " . expand('<cword>')<CR>
" nnoremap <C-g>           :execute "GitGrep " . expand('<cword>')<CR>
nnoremap <C-g>           :GitGrep<Space>
nnoremap <C-a>           :Grep6<Space>
nnoremap <leader><F3>    :Tags<CR>
nnoremap <leader>.       :GFiles<CR>
nnoremap <leader><F4>    :Files<CR>
nnoremap <leader>,       :Buffers<CR>



" =============================================================
" Auto hightlight extra whitespace
" http://vim.wikia.com/wiki/VimTip396
" =============================================================
" use this command to list available colors
" :syn list vimHiCtermColor
"
" Highlight extra whitespaces with :highlight and :match
:highlight ExtraWhitespace ctermbg=darkblue guibg=darkgray
:match ExtraWhitespace /\s\+$\| \+\ze\t/
":match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/
"                       ^^^^^^   ^^^^^^^  ^^^^^^^^^^^^
"                         (1)      (2)        (3)
"
" (1) trailing white spaces
" (2) spaces before a tab
" (3) tabs that are not at the start of a line
"
" Show tab and trailing whitespaces with speical characters
" :help listchars
"set list listchars=eol:¬,tab:»·,trail:·,extends:>,precedes:<,space:␣
set list listchars=tab:»·,trail:·




"" =============================================================
"" Persistent Undo
"" :help persistent-undo
"" :help undo-persistence
"" =============================================================
"set undofile                " Save undo's after file closes
"set undodir=$HOME/.vim/undo " where to save undo histories
"set undolevels=1000         " How many undos (default 1000 for Unix)
"set undoreload=10000        " number of lines to save for undo (default 10000)




" =============================================================
" Spell check and highlight
" http://vimdoc.sourceforge.net/htmldoc/spell.html
" =============================================================
" use aspell as spellchecker
" keymap to Ctrl-T
"map  :w!<CR>:!aspell check %<CR>:e! %<CR>

"set spell spelllang=en
nnoremap <F12> :setlocal spell! spelllang=en<CR>
" zg to add word to word list
" zw to reverse
" zug to remove word from word list
" z= to get list of possibilities
set spellfile=~/.vim/spellfile.add

highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline




" =============================================================
" modeline magic
" http://vim.wikia.com/wiki/Modeline_magic
" :help auto-setting
" :help modeline
" :help modelines
" =============================================================
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
    \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
call append(line("$"), l:modeline)
endfunction
" nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
nnoremap <leader><F12> :call AppendModeline()<CR>



" =============================================================
"  Show changes made to current buffer since the last save
" https://github.com/vim-scripts/diffchanges.vim
" =============================================================
nnoremap <leader>d :DiffChangesDiffToggle<CR>



" =============================================================
" tabs and indentation mess
" http://tedlogan.com/techblog3.html
" http://vim.wikia.com/wiki/VimTip1592
" http://vim.wikia.com/wiki/Toggle_between_tabs_and_spaces
" https://stackoverflow.com/questions/69998/tabs-and-spaces-in-vim
" =============================================================
"
" :tabstop (ts)
" Set tabstop to tell vim how many columns a tab counts for.
"
" :expandtab (et)
" When expandtab is set, hitting Tab in insert mode will produce the
" appropriate number of spaces.
"
" :shiftwidth (sw)
" Set shiftwidth to control how many columns text is indented with the
" reindent operations (<< and >>) and automatic C-style indentation.
"
" :softtabstop (sts)
" Set softtabstop to control how many columns vim uses when you hit Tab in insert mode.
" If softtabstop is less than tabstop and expandtab is not set, vim will use a combination
" of tabs and spaces to make up the desired spacing. If softtabstop equals tabstop and
" expandtab is not set, vim will always use tabs. When expandtab is set, vim will always
" use the appropriate number of spaces.
"
" :autoindent (ai)
" :help ai
"
" :smartindent (si)
" :help si


" global indent configs
" ---------------------
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent


" Settings per filetype
" ---------------------
autocmd filetype html,xhtml,htm     setlocal sts=2 sw=2
autocmd filetype xml,yml,yaml       setlocal sts=2 sw=2
autocmd filetype javascript,css     setlocal sts=2 sw=2


" Indent size getter/setter
function! g:IndentSize(...)
  if a:0 == 0
    " get indent size info when no args
    echo 'tabstop=' . &ts . ' softtabstop=' . &sts . ' shiftwidth=' . &shiftwidth . ' expandtab=' . &et
  else
    " set indent sizes when arg is given
    " execute ':set tabstop=' . a:1 . ' softtabstop=' . a:1 . ' shiftwidth=' . a:1
    execute ':set softtabstop=' . a:1 . ' shiftwidth=' . a:1
    set expandtab
  endif
endfunction
:command! -nargs=? IndentSize :call IndentSize(<f-args>)
nnoremap <F11> :IndentSize<Space>

" Set leading spaces from A to B
function! g:Respace(line1, line2, ...)
  " if only one argument is given, assume A is &softtabstop
  let A = (a:0 == 1) ? &shiftwidth : a:1
  let B = (a:0 == 1) ? a:1 : a:2
  execute a:line1 . ',' . a:line2 . 's#^\( \{' . A . '\}\)\+#\=repeat(" ",' . B . '*len(submatch(0))/' . A . ')'
endfunction
:command! -range=% -nargs=* Respace :call Respace(<line1>, <line2>, <f-args>)
noremap <leader><F11> :Respace<space>

" https://stackoverflow.com/questions/69998/tabs-and-spaces-in-vim
" convert all TAB to SPACE
" :set et
" :ret!
" convert all SPACE to TAB
" :set et!
" :ret!
"
" http://vim.wikia.com/wiki/Toggle_between_tabs_and_spaces
" https://stackoverflow.com/questions/16888658/change-2-space-indent-to-4-space-in-vim
" Convert every 2-space to a TAB
" :set ts=2 sts=2 noet
" :retab!
" Convert all TAB to 4-space
" :set ts=4 sts=4 et
" :retab



" =============================================================
" Status line (DEPRECATED by vim-airline)
" =============================================================
" NOTE: currently turned off, delegated to Airline
""set statusline=[%02n]\ %f\ %(\[%M%R%H]%)%=\ %4l,%02c%2V\ %P%*
"let s  = ""
"let s .= "%<"                                 | " truncate at the start
"let s .= "%f%8* "                             | " file name
"let s .= "%r"                                 | " readonly flag
"let s .= '%{&bomb?"!":""} '                   | " byte-order mark flag
"let s .= "%*%="                               | " right-justify after here
"let s .= "%9*%m%* "                           | " modified flag
"let s .= "0x%02B "                            | " hex value of current byte
"let s .= "%l"                                 | " current line
"let s .= ":%c%V"                              | " column number, virtual column (if different)
"let s .= " %P"                                | " percentage
"let s .= "/%LL"                               | " number of lines
"set statusline=%!s



" =============================================================
" Key Mappings
"
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_1%29
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_2%29
" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_%28Part_3%29
"
" difference between remap/noremap/nnoremap/vnoremap
" https://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping

" :map  | show all maps for the current buffer
" :map! | same as above, except showing output in a mini-window
" :nmap | only show normal mode maps
" :imap | only show insert mode maps
" :vmap | only show visual and select mode maps
" :smap | only show select mode maps
" :xmap | only show visual mode maps
" :cmap | only show command-line mode maps
" :omap | only show operator pending mode maps
"
" Special characters:
" <BS>           backspace
" <Tab>          tab
" <CR>           enter
" <Enter>        enter
" <Return>       enter
" <Esc>          escape
" <Space>        space
" <Up>           up arrow
" <Down>         down arrow
" <Left>         left arrow
" <Right>        right arrow
" <F1> - <F12>   function keys 1 to 12
" #1, #2..#9,#0  function keys f1 to f9, f10
" <Insert>       insert
" <Del>          delete
" <Home>         home
" <End>          end
" <PageUp>       page-up
" <PageDown>     page-down
" <bar>          the '|' character, which otherwise needs to be escaped '\|'
" =============================================================

" registers/marks
nnoremap <leader>r  :registers<CR>
nnoremap <leader>m  :marks<CR>

" buffer editnew/delete/update(save if modified)
nnoremap <C-n>      :enew<CR>
nnoremap <C-q>      :bd<CR>
noremap <C-s>       <Esc>:update<CR>

" buffer next/prev
nnoremap <S-Tab>    :bnext<CR>
nnoremap <S-q>      :bprev<CR>

" " ctags
" "nnoremap <F3> :execute "stselect " . expand('<cword>')<CR>
nnoremap <F3> g] expand('<cword>')
" nnoremap <leader><F3> 



" window splits
" (leader) F5, F6, F7, F8 to split and resize windows
" also see
" :help opening-window
" :help window-resize
nnoremap <leader><F5> :vsplit<CR>
nnoremap <F5> <
nnoremap <F6> >
nnoremap <leader><F6> :split<CR>
nnoremap <F7> -
nnoremap <F8> +
nnoremap <leader><F7> :hide<CR>
nnoremap <leader><F8> :only<CR>

" :help window-move-cursor
" noremap <C-p> <C-W>p
" noremap <C-o> <C-W>w

" " :help window-moving
" nnoremap <C-J> <C-W>J
" nnoremap <C-K> <C-W>K
" nnoremap <C-H> <C-W>H
" nnoremap <C-L> <C-W>l

" toggle line numbers
nnoremap <F9> :set number!<CR>

" toggle paste mode
nnoremap <F10> :set paste!<CR>

" handy mapping for search and replace
" flag n: show numbers of matches (help: count-items)
" flag c: confirm
" flag g: multiple matches on the same line
nnoremap <C-h> :%s:::g<Left><Left><Left>
vnoremap <C-h> :s:::g<Left><Left><Left>
" nnoremap ;' :%s:::cg<Left><Left><Left><Left>
" vnoremap ;' :s:::cg<Left><Left><Left><Left>

" remove leading whitespaces
function! g:RemoveLeadingWritespaces(line1, line2)
  execute a:line1 . ',' . a:line2 . 's/^\s\+\(\S\)/\1/e'
  "                                             ^----- The e flag in the substitute
  "command ensures that no error will be shown if no trailing whitespace is found
endfunction
:command! -range=% RemoveLeadingWritespaces :call RemoveLeadingWritespaces(<line1>, <line2>)

:command! -range=% RemoveTrailingWritespaces :call RemoveTrailingWritespaces(<line1>, <line2>)
" remove trailing whitespaces
function! g:RemoveTrailingWritespaces(line1, line2)
  execute a:line1 . ',' . a:line2 . 's/\s\+$//e'
  "                                           ^----- The e flag in the substitute
  "command ensures that no error will be shown if no trailing whitespace is found
endfunction
:command! -range=% RemoveTrailingWritespaces :call RemoveTrailingWritespaces(<line1>, <line2>)

" remove empty lines
function! g:RemoveEmptyLines(line1, line2)
  execute a:line1 . ',' . a:line2 . 'v/\S/d'
endfunction
:command! -range=% RemoveEmptyLines :call RemoveEmptyLines(<line1>, <line2>)



" Summary of key mappings
" -----------------------
" <leader>,       | ctrlp
" <leader>.       | NERDTreeToggle
" <leader>u       | GundoToggle
" \               | EasyAlign
" <leader>d       | diff changes
" <leader>f       | fzf search open buffers
" <leader>b       | fzf Buffers
" <S-Tab>         | buffer next
" <S-q>           | buffer prev
" <leader><Tab>   | IndentSize
" <leader><Space> | Respace
" <leader>r       | show registers
" <leader>m       | show marks
" mm              | toggle mark at current line
" m<BS>           | remove all marks
" ;               | global search and replace
" <C-n>           | new buffer
" <C-k>           | buffer delete
" <C-s>           | update (save when buffer is modified)
" <C-a>           | save as
" <F3>            | ctags jump
" <leader><F3>    | ctags jump backward
" <F4>            | fzf Ag search
" <F5>-<F8>       | window split operations
" <F9>            | toggle line numbers
" <F10>           | toggle paste mode
" <F12>           | toggle spellcheck
" <leader><F12>   | AppendModeline()
"
" Listing key mappings
" --------------------
" :map               | list all key mappings
" :verbose map       | similar to above, verbose version
" :map ,             | list key mappings starting with ,
" :verbose map ,     | similar to above, verbose version
" :map <leader>      | list key mappings starting with <leader>




" =============================================================
" Vim Cheatsheets
" =============================================================

" Vim Moving Around
" -----------------
"
" key | action
" --- | ------
" h   | move one character left
" j   | move one row down
" k   | move one row up
" l   | move one character right
" w   | move to beginning of next word
" b   | move to beginning of previous word
" e   | move to end of word
" W   | move to beginning of next word after a whitespace
" B   | move to beginning of previous word before a whitespace
" E   | move to end of word before a whitespace
"
" All the above movements can be preceded by a count; e.g. 4j will move down 4 lines.
"
" key | action
" --- | ------
" 0   | move to beginning of line
" $   | move to end of line
" ^   | move to first non-blank char of the line
" _   | same as above, but can take a count to go to a different line
" g_  | move to last non-blank char of the line (can also take a count as above)
"
" key | action
" --- | ------
" gg  | move to first line
" G   | move to last line
" nG  | move to n'th line of file (where n is a number)
"
" key | action
" --- | ------
" H   | move to top of screen
" M   | move to middle of screen
" L   | move to bottom of screen
"
" key | action
" --- | ------
" z.  | put the line with the cursor at the center
" zt  | put the line with the cursor at the top
" zb  | put the line with the cursor at the bottom of the screen
"
" key    | action
" ---    | ------
" Ctrl-D | move half-page down
" Ctrl-U | move half-page up
" Ctrl-B | page up
" Ctrl-F | page down
" Ctrl-o | jump to last cursor position
" Ctrl-i | jump to next cursor position
"
" key | action
" --- | ------
" n   | next matching search pattern
" N   | previous matching search pattern
" *   | next word under cursor
" #   | previous word under cursor
" g*  | next matching search pattern under cursor
" g#  | previous matching search pattern under cursor
"
"
" key | action
" --- | ------
" %   | jump to matching bracket { } [ ] ( )



" Sort Lines
" ----------
" :%sort   | sort
" :%sort!  | sort in reverse
" :%sort u | sort, and remove duplicates
" :%sort n | numeric sort



" Power of g
" ----------
" http://vim.wikia.com/wiki/Power_of_g
"
" :g/^\s*$/d        | delete empty lines in file
" :g!/\S/d          | delete empty lines in file
" :v/\S/d           | delete empty lines in file
" :g/^/pu =\"\n\"   | double space the file
" :g/^/pu _         | double space the file
" qaq:g/pattern/y A | copy all lines matching a pattern to register 'a'
"                   | explanation: qaq is a trick to clear register a (qa starts recording a
"                   | macro to register a, then q stops recording, leaving a empty). y A is an
"                   | Ex command (:help :y). It yanks the current line into register A (append
"                   | to register a).
" :g/pattern/d_     | FAST delete of all lines matching a pattern
" :v/pattern/p      | negate search pattern



" Move/Copy Whole Lines
" ---------------------
" :help m[ove]
" :help co[py]
"
" :2,8co15  | copy lines 2 through 8 after line 15
" :4,15t$   | copy lines 4 through 15 to end of document (t == co)
" :-t$      | copy previous line to end of document
" :m0       | move current line to line 0 (i.e. the top of the document)
" :.,+3m$-1 | current line through current+3 are moved to the lastLine-1 (i.e. next to last)



" Escaped Characters (regex)
" --------------------------
" http://vimregex.com/
"
" .   any character except new line
" \s  whitespace character
" \S  non-whitespace character
" \d  digit
" \D  non-digit
" \x  hex digit
" \X  non-hex digit
" \o  octal digit
" \O  non-octal digit
" \h  head of word character (a,b,c...z,A,B,C...Z and _)
" \H  non-head of word character
" \p  printable character
" \P  like \p, but excluding digits
" \w  word character
" \W  non-word character
" \a  alphabetic character
" \A  non-alphabetic character
" \l  lowercase character
" \L  non-lowercase character
" \u  uppercase character
" \U  non-uppercase character



" Regular Expression Special Characters **Not** Requiring Escaping
" ----------------------------------------------------------------
" http://jeetworks.org/vim-regular-expression-special-characters-to-escape-or-not-to-escape/
"
" Quantifier | Description
" ---------- | -----------
" \          | Escape next character (use '\\' for literal backslash)
" ^          | Start-of-line (at start of pattern)
" $          | End-of-line
" .          | Matches any character
" *          | Matches 0 or more occurrences of the previous atom
" ~          | Matches last given substitute string
" [...]      | Matches any of the characters given within the brackets
" [^...]     | Matches any character not given within the brackets
" &          | In replacement pattern: insert the whole matched search pattern

" Regular Expression Special Characters Requiring Escaping
" --------------------------------------------------------
" http://jeetworks.org/vim-regular-expression-special-characters-to-escape-or-not-to-escape/
"
" Quantifier | Description
" ---------- | -----------
" \<         | Matches beginning of a word (left word break/boundary)
" \>         | Matches end of a word (right word break/boundary)
" \(...\)    | Grouping into an atom
" \|         | Separating alternatives
" \_.        | Matches any single character or end-of-line
" \+         | 1 or more of the previous atom (greedy)
" \=         | 0 or one of the previous atom (greedy)
" \?         | 0 or one of the previous atom (greedy)
" \{         | Multi-item count match specification (greedy).
" \{-        | Multi-item count match specification (non-greedy).

" http://vim.wikia.com/wiki/Search_and_replace
"
" When searching:
"     ., *, \, [, ], ^, and $ are metacharacters.
"     +, ?, |, {, }, (, and ) must be escaped to use their special function.
"     \/ is / (use backslash + forward slash to search for forward slash)
"     \t is tab, \s is whitespace
"     \n is newline, \r is CR (carriage return = Ctrl-M = ^M)
"     \{#\} is used for repetition. /foo.\{2\} will match foo and the two following characters. The \ is not required on the closing } so /foo.\{2} will do the same thing.
"     \(foo\) makes a backreference to foo. Parenthesis without escapes are literally matched. Here the \ is required for the closing \).
"
" When replacing:
"     \r is newline, \n is a null byte (0x00).
"     \& is ampersand (& is the text that matches the search pattern).
"     \0 inserts the text matched by the entire pattern
"     \1 inserts the text of the first backreference. \2 inserts the second backreference, and so on.



" Copying and Pasting Text (with registers)
" -----------------------------------------
"
" {a-zA-Z0-9.%#:-"}          | Use register {a-zA-Z0-9.%#:-"} for next delete, yank or put (use uppercase character to append with delete and yank) ({.%#:} only work with put).
" :reg[isters]               | Display the contents of all numbered and named registers.
" :reg[isters] {arg}         | Display the contents of the numbered and named registers that are mentioned in {arg}.
" :di[splay] [arg]           | Same as :registers.
" ["x]y{motion}              | Yank {motion} text [into register x].
" ["x]yy                     | Yank [count] lines [into register x]
" ["x]Y                      | yank [count] lines [into register x] (synonym for yy).
" {Visual}["x]y              | Yank the highlighted text [into register x] (for {Visual} see Selecting Text).
" {Visual}["x]Y              | Yank the highlighted lines [into register x]
" :[range]y[ank] [x]         | Yank [range] lines [into register x].
" :[range]y[ank] [x] {count} | Yank {count} lines, starting with last line number in [range] (default: current line), [into register x].
" ["x]p                      | Put the text [from register x] after the cursor [count] times.
" ["x]P                      | Put the text [from register x] before the cursor [count] times.
" ["x]gp                     | Just like "p", but leave the cursor just after the new text.
" ["x]gP                     | Just like "P", but leave the cursor just after the new text.
" :[line]pu[t] [x]           | Put the text [from register x] after [line] (default current line).
" :[line]pu[t]! [x]          | Put the text [from register x] before [line] (default current line).



" gq Magic - format lines to 'textwidth' length
" ---------------------------------------------
" :help gq
"
" gqap or {Visual}gq
" gwap or {Visual}gw

" join lines -- visual select entire paragraph, and then press J
" {Visual}J



" Text Objects
" ------------
" :help text-objects
" http://blog.carbonfive.com/2011/10/17/vim-text-objects-the-definitive-guide/
"
" prefix | action
" ------ | ------
" d      | delete
" c      | change
" y      | yank
" v      | visual
"
" suffix         | meaning
" ------         | -------
" aw/iw          | Word by punctuation
" aW/iW          | Word by whitespace (:help WORD)
" as/is          | Sentence
" ap/ip          | Paragraph
" a'/i' or a"/i" | Quotes
" a)/i)          | Parentheses
" a]/i]          | Brackets
" a}/i}          | Braces
" a>/i>          | Angle Brackets
" at/it          | Tags (e.g. <html>inner</html>)
"
" Simple Examples
" ---------------
" dl  | delete character (alias: x)
" diw | delete inner word
" daw | delete a word
" diW | delete inner WORD
" daW | delete a WORD
" dgn | delete the next search pattern match
" dd  | delete one line
" dis | delete inner sentence
" das | delete a sentence
" dib | delete inner '(' ')' block
" dab | delete a '(' ')' block
" dip | delete inner paragraph
" dap | delete a paragraph
" diB | delete inner '{' '}' block
" daB | delete a '{' '}' block
"
" More Examples
" -------------
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
"
" Copy a word and paste it over other words:
" yiw     yank inner word (copy word under cursor, say "first").
" ...     Move the cursor to another word (say "second").
" viwp    select "second", then replace it with "first".
" ...     Move the cursor to another word (say "third").
" viw"0p  select "third", then replace it with "first".
"
" Copy a line and paste it over other lines:
" yy      yank current line (say "first line").
" ...     Move the cursor to another line (say "second line").
" Vp      select "second line", then replace it with "first line".
" ...     Move the cursor to another line (say "third line").
" V"0p    select "third line", then replace it with "first line".



" Changing Case
" -------------
" http://vim.wikia.com/wiki/Switching_case_of_characters
"
" :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g | converts the current line to Title Case
"
" g~$                             | toggle case of all characters to end of line
"
" gUw                             | uppercase from current cursor till end of word
" guw                             | lowercase from current cursor till end of word
" g~w                             | toggle case from current cursor till end of word
"
" gUiw                            | uppercase current word (inner word – cursor anywhere in word)
" guiw                            | lowercase current word (inner word – cursor anywhere in word)
" g~iw                            | toggle case current word (inner word – cursor anywhere in word)
"
" guu                             | lowercase line
" gUU                             | uppercase line
" g~~                             | toggle case Line
"
" Vu                              | lowercase line
" VU                              | uppercase line
" V~                              | toggle case line
"
" gggUG                           | uppercawe entire file
" ggguG                           | lowercase entire file
" ggg~G                           | toggle entire file
"
" " Titlise Visually Selected Text (map for .vimrc)
" vmap ,c :s/\<\(.\)\(\k*\)\>/\u\1\L\2/g<CR>
" " Title Case A Line Or Selection (better)
" vnoremap <F6> :s/\%V\<\(\w\)\(\w*\)\>/\u\1\L\2/ge<cr> [N]
" " titlise a line
" nmap ,t :s/.*/\L&/<bar>:s/\<./\u&/g<cr>  [N]
" " Uppercase first letter of sentences
" :%s/[.!?]\_s\+\a/\U&\E/g


" :help Help
" ----------
" :helpg pattern        | search grep!! ---  JUMP TO OTHER MATCHES WITH: >
" :help holy-grail      |
" :help all             |
" :help termcap         | termcap help
" :help user-toc.txt    | Table of contents of the User Manual. >
" :help :subject        | Ex-command "subject", for instance the following: >
" :help :help           | Help on getting help. >
" :help CTRL-B          | Control key <C-B> in Normal mode. >
" :help 'subject'       | Option 'subject'. >
" :help EventName       | Autocommand event "EventName"
" :help pattern<Tab>    | Find a help tag starting with "pattern". Repeat <Tab> for others. >
" :help pattern<Ctrl-D> | See all possible help tag matches "pattern" at once. >
" :cn                   | next match >
" :cprev, :cN           | previous match >
" :cfirst, :clast       | first or last match >
" :copen,  :cclose      | open/close the quickfix window; press <Enter> to jump to the item under the cursor


" Set things ...
" --------------
" :verbose set opt? - show where opt was set
" set opt!       | invert
" set invopt     | invert
" set opt&       | reset to default
" set all&       | set all to def
" :se[t]         | Show all options that differ from their default value.
" :se[t] all     | Show all but terminal options.
" :se[t] termcap | Show all terminal options.  Note that in the GUI the


" Tabs
" ----
" tc | create a new tab
" td | close a tab
" tn | next tab
" tp | previous tab


" Uppercase, Lowercase, Indents
" -----------------------------
" '.         | last modification in file!
" gf         | open file under cursor
" guu        | lowercase line
" gUU        | uppercase line
" {Visual}gu | lowercase selection
" {Visual}gU | uppercase selection
" =          | reindent text


" Folds
" -----
" zr | less folds
" zR | open all folds
" zm | more folds
" zM | close all folds
" za | toggle current fold
" zA | toggle current fold at all levels


" Key Sequence
" ------------
" CTRL-I     | forward trace of changes
" CTRL-O     | backward trace of changes!
" C-W W      | switch to other split window
" CTRL-U     | delete from cursor to start of line
" CTRL-^     | switch between files
" CTRL-W-TAB | create duplicate window
" CTRL-N     | find keyword for word in front of cursor
" CTRL-P     | Find PREV ditto


" Search and Replace
" ------------------
" :%s/^\s\+//                   | delete leading whitespaces
" :%s/\s\+$//                   | delete trailing whitespaces
" :%s/a\|b/xxx\0xxx/g           | modifies a b      to xxxaxxxbxxx
" :%s/\([abc]\)\([efg]\)/\2\1/g | modifies af fa bg to fa fa gb
" :%s/abcde/abc^Mde/            | modifies abcde    to abc, de (two lines)
" :%s/$/\^M/                    | modifies abcde    to abcde^M
" :%s/\w\+/\u\0/g               | modifies bla bla  to Bla Bla


" (Read from / write to) other file
" ---------------------------------
" :r file                 | read text from file and insert below current line
" {Visual}w ! cat >> file | append visually selected text to <file>


" List show print
" ---------------
" :hist[ory]    | show history
" :ju[mps]      | print jump list
" :marks        | show marks
" :reg[gisters] | show registers
" :di[splay]    | ditto
" :buffers      | show buffers
" :ls           | ditto


" Save / SaveAs
" -------------
" :w           | save changes
" :w newfile   | save changes to newfile, keep editing the existing buffer
" :sav newfile | save changes to newfile, and switch editing to new buffer


" Random stuff
" ------------
" :!!date              | insert date
" :%!sort -u           | only show uniq (and sort)
" :v/./.,/./-1join     | join empty lines
" :g/^\s*$/;//-1sort   | to sort each block of lines in a file.
" :e!                  | return to unmodified file
" :w !colordiff -u % - | view diff of edits against buffer vs original file
" :r! echo %           | insert current filename
" :%s/\s\+$//          | delete trailing whitespace
" :nohl                | no highlight
" :noh                 | ditto
" :set [nu]mber        | set line numbers
" :set [nonu]mber      | unset line numbers
" :set nu!             | toggle line numbers
" :E[xplore]           | opens the file explorer window
" :EasyAlign           | align selected area with delimiter


" {Visual}
" --------
" {Visual-Line}!tac | reverse lines
" {Visual}~         | toggle case


" Buffers
" -------
" :buffers        | show buffers
" :ls             | ditto
" :bn             | next buffer
" :bp             | prev buffer
" :bd             | delete current buffer
" :b #            | jump to buffer #
" :tab sball      | put all open buffers in tabs
" :sbn            | split buffer next
" :sbl            | split buffer last
" :sbm            | split buffer modified
" :vnew           | create a new window vertially with a new empty file
" :vs or ctrl-w v | split current windown in 2 vertically


" Plugins / Shared libraries
" --------------------------
" :runtime! plugin/**/*.vim             | load plugins
" :so $VIMRUNTIME/syntax/hitest.vim     | view highlight options
" :so $VIMRUNTIME/syntax/colortest.vim  |
