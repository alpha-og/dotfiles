let mapleader = " "
let maplocalleader = ";"

" File search paths and wildcard exclusions
set path+=**
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/build/**
set wildmenu
set wildmode=full

" Core editor options
set clipboard=unnamedplus,unnamed
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab smartindent
set wrap number relativenumber cursorline signcolumn=yes scrolloff=10
set ignorecase smartcase nohlsearch incsearch
set termguicolors background=dark noshowmode cmdheight=1
set hidden noerrorbells noswapfile nobackup undofile undodir=~/.vim/undodir_vim
set backspace=indent,eol,start splitright splitbelow noautochdir
set selection=exclusive mouse=a encoding=utf-8
set completeopt=menuone,noinsert,noselect iskeyword+=-
set foldmethod=marker foldlevel=99
" 0 = Never show the dedicated status line window
set laststatus=0

" Enable the ruler (prints info in the empty space of the command line)
set ruler

" Customize what the ruler shows (File name, modified flag, line/col number)
set rulerformat=%30(%=\ %f\ %m\ %l:%c%)

" Enable syntax and filetype detection engines
filetype plugin indent on
syntax enable

" Enable native Vim manual pager
runtime ftplugin/man.vim
set keywordprg=:Man

" Status line
set laststatus=2
set statusline=%f\ %m%r%=%{&fileencoding?&fileencoding:&encoding}\ %{&fileformat}\ %y\ %p%%\ %l:%c

" Netrw options
let g:netrw_banner = 0
let g:netrw_liststyle = 4
let g:netrw_hide = 0
let g:netrw_winsize = 25

" Highlight overrides
hi clear SpellBad
hi SpellBad cterm=underline gui=underline

" In-memory Ripgrep command to prevent shell pollution and rendering artifacts
command! -nargs=+ Rg cgetexpr system('rg --vimgrep --smart-case --hidden --color=never --glob=!.git/ ' . shellescape(<q-args>)) | cwindow

" Window management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <S-C-h> <C-w><
nnoremap <S-C-l> <C-w>>
nnoremap <S-C-j> <C-w>-
nnoremap <S-C-k> <C-w>+
nnoremap <leader><leader>h <C-w>r
nnoremap <leader><leader>j <C-w>r
nnoremap <leader><leader>k <C-w>r
nnoremap <leader><leader>l <C-w>r

" Editor interactions
nnoremap <leader>e :Lexplore<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
xnoremap <leader>p "_dP
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
nnoremap <S-u> <C-u>
nnoremap <S-d> <C-d>
nnoremap <leader>rr :source $MYVIMRC<CR>:echo "Config reloaded"<CR>

" File, buffer, and grep search operations
nnoremap <leader><space> :find_
nnoremap <leader>ff :find 
nnoremap <leader>/ :Rg<Space>
nnoremap <leader>sg :Rg<Space>
nnoremap <leader>sw :execute 'Rg ' . expand('<cword>')<CR>
nnoremap <leader>fg :execute 'args ' . join(split(system('git ls-files')), ' ')<CR>
nnoremap <leader>fb :ls<CR>:b<Space>
nnoremap <leader>fc :edit $MYVIMRC<CR>
nnoremap <leader>fp :cd<Space>
nnoremap <leader>fr :browse oldfiles<CR>
nnoremap <leader>bd :bdelete<CR>

" Miscellaneous search and registers
nnoremap <leader>: :history :<CR>
nnoremap <leader>n :messages<CR>
nnoremap <leader>sb :g//<Left>
nnoremap <leader>sB :bufdo grepadd<Space>
nnoremap <leader>s" :registers<CR>
nnoremap <leader>s/ :history /<CR>
nnoremap <leader>sa :autocmd<CR>
nnoremap <leader>sc :history :<CR>
nnoremap <leader>sC :command<CR>
nnoremap <leader>sd :clist<CR>
nnoremap <leader>sD :clist<CR>
nnoremap <leader>sh :help<Space>
nnoremap <leader>sH :highlight<CR>
nnoremap <leader>sj :jumps<CR>
nnoremap <leader>sk :map<CR>
nnoremap <leader>sl :lopen<CR>
nnoremap <leader>sm :marks<CR>
nnoremap <leader>sM :Man<Space>
nnoremap <leader>sp :scriptnames<CR>
nnoremap <leader>sq :copen<CR>
nnoremap <leader>sR @:
nnoremap <leader>su :undolist<CR>
nnoremap <leader>sS :tselect<CR>
nnoremap <leader>ss :tselect<CR>
nnoremap <leader>si :echo "Icons require a Nerd Font"<CR>

" UI and Quickfix toggles
nnoremap <leader>xx :copen<CR>
nnoremap <leader>xX :cexpr []<CR>:copen<CR>
nnoremap <leader>cs :tselect<CR>
nnoremap <leader>cl :tselect<CR>
nnoremap <leader>xL :lopen<CR>
nnoremap <leader>xQ :copen<CR>
nnoremap <leader>ut :undolist<CR>
nnoremap <leader>uC :colorscheme<Space>
nnoremap <leader>us :set spell!<CR>
nnoremap <leader>uw :set wrap!<CR>
nnoremap <leader>uL :set relativenumber!<CR>
nnoremap <leader>ud :let &signcolumn = (&signcolumn ==# 'yes' ? 'no' : 'yes')<CR>
nnoremap <leader>ul :set number!<CR>
nnoremap <leader>uc :let &conceallevel = (&conceallevel == 0 ? 2 : 0)<CR>
nnoremap <leader>ub :let &background = (&background ==# 'dark' ? 'light' : 'dark')<CR>
nnoremap <leader>ug :set list!<CR>
nnoremap <leader>uT :echo "Treesitter unavailable in Vim"<CR>
nnoremap <leader>uh :echo "Inlay hints unavailable in Vim"<CR>
nnoremap <leader>uD :echo "Dim unavailable in Vim"<CR>

" Helper to run TUI applications safely
function! s:run_tui(cmd) abort
  let l:bin = split(a:cmd)[0]
  if executable(l:bin)
    execute 'tab terminal ++close ' . a:cmd
  else
    echohl ErrorMsg 
    echom "'" . l:bin . "' is not installed or missing from PATH." 
    echohl None
  endif
endfunction

" Terminal Drawer Logic
let s:drawer_term_buf = -1
let s:drawer_term_win = -1

function! s:toggle_terminal_drawer() abort
  if win_gotoid(s:drawer_term_win)
    hide
    let s:drawer_term_win = -1
    return
  endif

  if bufexists(s:drawer_term_buf)
    execute 'botright 15split'
    execute 'buffer ' . s:drawer_term_buf
  else
    botright terminal ++rows=15
    let s:drawer_term_buf = bufnr('%')
  endif

  let s:drawer_term_win = win_getid()
  setlocal nobuflisted
  startinsert
endfunction

" Zoxide directory navigation integration
function! s:zoxide_cd() abort
  if !executable('zoxide')
    echohl ErrorMsg | echom "Zoxide is not installed or missing from PATH." | echohl None
    return
  endif

  let l:query = input('zoxide> ')
  if empty(l:query)
    return
  endif

  let l:result = system('zoxide query ' . shellescape(l:query))
  let l:result = substitute(l:result, '\n\+$', '', '')

  if v:shell_error == 0 && isdirectory(l:result)
    execute 'cd ' . fnameescape(l:result)
    redraw
    echom "Directory changed to: " . l:result
  else
    redraw
    echohl ErrorMsg | echom "Zoxide: No match found for '" . l:query . "'" | echohl None
  endif
endfunction

" Dumps static command output into a clean, searchable temporary tab
function! s:run_git_scratch(cmd) abort
  let l:output = system(a:cmd)
  tabnew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  
  call setline(1, split(l:output, "\n"))
  normal! gg

  if a:cmd =~# 'diff' || a:cmd =~# 'log' || a:cmd =~# 'blame'
    setlocal filetype=git
  elseif a:cmd =~# 'status'
    setlocal filetype=gitcommit
  endif

  nnoremap <buffer> <silent> q :tabclose<CR>
endfunction

" Toggle the terminal drawer open and closed
nnoremap <leader>tt :call <SID>toggle_terminal_drawer()<CR>
tnoremap <leader>tt <C-\><C-n>:call <SID>toggle_terminal_drawer()<CR>

" Standard split terminals
nnoremap <leader>tv :vertical terminal<CR>
nnoremap <leader>th :terminal<CR>
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <C-[><C-[> <C-\><C-n>

" Terminals and Git integration
nnoremap <leader>lg :call <SID>run_tui('lazygit')<CR>
nnoremap <leader>ld :call <SID>run_tui('lazydocker')<CR>

nnoremap <leader>gc :call <SID>run_git_scratch('git blame ' . shellescape(expand('%')))<CR>
nnoremap <leader>gb :call <SID>run_git_scratch('git branch')<CR>
nnoremap <leader>gl :call <SID>run_git_scratch('git log --oneline')<CR>
nnoremap <leader>gL :call <SID>run_git_scratch('git log -L ' . line('.') . ',+1:' . shellescape(expand('%')))<CR>
nnoremap <leader>gs :call <SID>run_git_scratch('git status')<CR>
nnoremap <leader>gS :call <SID>run_git_scratch('git stash list')<CR>
nnoremap <leader>gd :call <SID>run_git_scratch('git diff')<CR>
nnoremap <leader>gf :call <SID>run_git_scratch('git log -- ' . shellescape(expand('%')))<CR>
nnoremap <leader>z  :call <SID>zoxide_cd()<CR>

" LSP fallbacks
nnoremap <leader>ca :echo "Code actions need LSP"<CR>
nnoremap <leader>dl :clist<CR>
nnoremap <leader>dn :cnext<CR>zz
nnoremap <leader>dp :cprev<CR>zz

" Harpoon logic
function! s:harpoon_add() abort
  for c in ['H', 'I', 'J', 'K', 'L']
    if getpos("'" . c) == [0, 0, 0, 0]
      execute "mark " . c
      echom 'Harpoon: marked to slot ' . (char2nr(c) - char2nr('H') + 1)
      return
    endif
  endfor
  echo 'Harpoon: slots full (clear marks to proceed)'
endfunction

function! s:harpoon_select(n) abort
  if a:n < 1 || a:n > 5 | return | endif
  let c = nr2char(char2nr('H') + a:n - 1)
  try
    execute "normal! `" . c
  catch
    echo 'Harpoon slot ' . a:n . ' is empty'
  endtry
endfunction

function! s:harpoon_menu() abort
  echo 'Harpoon slots:'
  for i in range(5)
    let c = nr2char(char2nr('H') + i)
    let pos = getpos("'" . c)
    if pos != [0, 0, 0, 0] && pos[1] > 0
      let fname = bufname(pos[0])
      echom '  ' . (i+1) . ': ' . (fname != '' ? fname : '(no name)') . '  line ' . pos[1]
    else
      echom '  ' . (i+1) . ': (empty)'
    endif
  endfor
endfunction

nnoremap <leader>A :call <SID>harpoon_add()<CR>
nnoremap <leader>a :call <SID>harpoon_menu()<CR>
nnoremap <C-e>     :call <SID>harpoon_menu()<CR>
for s:i in range(1, 5)
  execute 'nnoremap <leader>' . s:i . ' :call <SID>harpoon_select(' . s:i . ')<CR>'
endfor
unlet s:i

" Autocommands
augroup editor_automation
  autocmd!
  
  " Automatically open the quickfix/location list after a search is executed
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
  
  " Filetype enforcement
  autocmd BufNewFile,BufRead *.ejs set filetype=ejs
  autocmd BufNewFile,BufRead *.astro set filetype=astro
  
  " Terminal state UI cleanup
  if exists('##TerminalOpen')
    autocmd TerminalOpen * setlocal nonumber norelativenumber
  elseif exists('##TermOpen')
    autocmd TermOpen * setlocal nonumber norelativenumber
  endif
  
  " Restore last cursor position on file open
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &filetype !~# 'commit\|gitrebase' |
    \   execute "normal! g`\"" |
    \ endif
  
  " Trim trailing whitespace on save for code files
  autocmd BufWritePre *.py,*.js,*.ts,*.lua,*.c,*.cpp,*.h,*.rs,*.java,*.sh,*.json,*.yaml,*.toml
    \ let s:save_cursor = getpos(".") |
    \ keeppatterns %s/\s\+$//e |
    \ call setpos(".", s:save_cursor) |
    \ unlet s:save_cursor
augroup END

" Context-aware documentation engine routing for Shift+K
augroup context_docs
  autocmd!
  autocmd FileType vim setlocal keywordprg=:help
  autocmd FileType python setlocal keywordprg=pydoc
  autocmd FileType ruby setlocal keywordprg=ri
  autocmd FileType go setlocal keywordprg=go\ doc
  autocmd FileType sh,c,cpp,rust setlocal keywordprg=:Man
augroup END

" Highlight yanked text asynchronously
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * call s:highlight_yank()
augroup END

function! s:highlight_yank() abort
  if exists('w:yank_match_id')
    try | call matchdelete(w:yank_match_id) | catch | endtry
  endif
  let w:yank_match_id = matchadd('IncSearch', '\%''\[\_.\{-}\%''\]') 
  call timer_start(120, { id -> s:clear_yank_highlight() })
endfunction

function! s:clear_yank_highlight() abort
  if exists('w:yank_match_id')
    try
      call matchdelete(w:yank_match_id)
    catch
    endtry
    unlet! w:yank_match_id
  endif
endfunction

" Debug utility
function! P(v)
  echo string(a:v)
  return a:v
endfunction

" vim: set ft=vim :

" Theme Engine: Catppuccin Mocha
hi clear
if exists('syntax on')
    syntax reset
endif

let g:colors_name='catppuccin_mocha'
set t_Co=256

let s:rosewater = "#F5E0DC"
let s:flamingo  = "#F2CDCD"
let s:pink      = "#F5C2E7"
let s:mauve     = "#CBA6F7"
let s:red       = "#F38BA8"
let s:maroon    = "#EBA0AC"
let s:peach     = "#FAB387"
let s:yellow    = "#F9E2AF"
let s:green     = "#A6E3A1"
let s:teal      = "#94E2D5"
let s:sky       = "#89DCEB"
let s:sapphire  = "#74C7EC"
let s:blue      = "#89B4FA"
let s:lavender  = "#B4BEFE"

let s:text      = "#CDD6F4"
let s:subtext1  = "#BAC2DE"
let s:subtext0  = "#A6ADC8"
let s:overlay2  = "#9399B2"
let s:overlay1  = "#7F849C"
let s:overlay0  = "#6C7086"
let s:surface2  = "#585B70"
let s:surface1  = "#45475A"
let s:surface0  = "#313244"
let s:base      = "#1E1E2E"
let s:mantle    = "#181825"
let s:crust     = "#11111B"

function! s:hi(group, guisp, guifg, guibg, gui, cterm) abort
  let cmd = ""
  if a:guisp != "" | let cmd = cmd . " guisp=" . a:guisp | endif
  if a:guifg != "" | let cmd = cmd . " guifg=" . a:guifg | endif
  if a:guibg != "" | let cmd = cmd . " guibg=" . a:guibg | endif
  if a:gui != ""   | let cmd = cmd . " gui=" . a:gui     | endif
  if a:cterm != "" | let cmd = cmd . " cterm=" . a:cterm | endif
  if cmd != ""     | exec "hi " . a:group . cmd          | endif
endfunction

call s:hi("Normal", "NONE", s:text, s:base, "NONE", "NONE")
call s:hi("Visual", "NONE", "NONE", s:surface1,"bold", "bold")
call s:hi("Conceal", "NONE", s:overlay1, "NONE", "NONE", "NONE")
call s:hi("ColorColumn", "NONE", "NONE", s:surface0, "NONE", "NONE")
call s:hi("Cursor", "NONE", s:base, s:rosewater, "NONE", "NONE")
call s:hi("lCursor", "NONE", s:base, s:rosewater, "NONE", "NONE")
call s:hi("CursorIM", "NONE", s:base, s:rosewater, "NONE", "NONE")
call s:hi("CursorColumn", "NONE", "NONE", s:mantle, "NONE", "NONE")
call s:hi("CursorLine", "NONE", "NONE", s:surface0, "NONE", "NONE")
call s:hi("Directory", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("DiffAdd", "NONE", s:base, s:green, "NONE", "NONE")
call s:hi("DiffChange", "NONE", s:base, s:yellow, "NONE", "NONE")
call s:hi("DiffDelete", "NONE", s:base, s:red, "NONE", "NONE")
call s:hi("DiffText", "NONE", s:base, s:blue, "NONE", "NONE")
call s:hi("EndOfBuffer", "NONE", "NONE", "NONE", "NONE", "NONE")
call s:hi("ErrorMsg", "NONE", s:red, "NONE", "bolditalic" , "bold,italic")
call s:hi("VertSplit", "NONE", s:crust, "NONE", "NONE", "NONE")
call s:hi("Folded", "NONE", s:blue, s:surface1, "NONE", "NONE")
call s:hi("FoldColumn", "NONE", s:overlay0, s:base, "NONE", "NONE")
call s:hi("SignColumn", "NONE", s:surface1, s:base, "NONE", "NONE")
call s:hi("IncSearch", "NONE", s:surface1, s:pink, "NONE", "NONE")
call s:hi("CursorLineNR", "NONE", s:lavender, "NONE", "NONE", "NONE")
call s:hi("LineNr", "NONE", s:surface1, "NONE", "NONE", "NONE")
call s:hi("MatchParen", "NONE", s:peach, "NONE", "bold", "bold")
call s:hi("ModeMsg", "NONE", s:text, "NONE", "bold", "bold")
call s:hi("MoreMsg", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("NonText", "NONE", s:overlay0, "NONE", "NONE", "NONE")
call s:hi("Pmenu", "NONE", s:overlay2, s:surface0, "NONE", "NONE")
call s:hi("PmenuSel", "NONE", s:text, s:surface1, "bold", "bold")
call s:hi("PmenuSbar", "NONE", "NONE", s:surface1, "NONE", "NONE")
call s:hi("PmenuThumb", "NONE", "NONE", s:overlay0, "NONE", "NONE")
call s:hi("Question", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("QuickFixLine", "NONE", "NONE", s:surface1, "bold", "bold")
call s:hi("Search", "NONE", s:pink, s:surface1, "bold", "bold")
call s:hi("SpecialKey", "NONE", s:subtext0, "NONE", "NONE", "NONE")
call s:hi("SpellBad", "NONE", s:base, s:red, "NONE", "NONE")
call s:hi("SpellCap", "NONE", s:base, s:yellow, "NONE", "NONE")
call s:hi("SpellLocal", "NONE", s:base, s:blue, "NONE", "NONE")
call s:hi("SpellRare", "NONE", s:base, s:green, "NONE", "NONE")
call s:hi("StatusLine", "NONE", s:text, s:mantle, "NONE", "NONE")
call s:hi("StatusLineNC", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("StatusLineTerm", "NONE", s:text, s:mantle, "NONE", "NONE")
call s:hi("StatusLineTermNC", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("TabLine", "NONE", s:surface1, s:mantle, "NONE", "NONE")
call s:hi("TabLineFill", "NONE", "NONE", s:mantle, "NONE", "NONE")
call s:hi("TabLineSel", "NONE", s:green, s:surface1, "NONE", "NONE")
call s:hi("Title", "NONE", s:blue, "NONE", "bold", "bold")
call s:hi("VisualNOS", "NONE", "NONE", s:surface1, "bold", "bold")
call s:hi("WarningMsg", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("WildMenu", "NONE", "NONE", s:overlay0, "NONE", "NONE")
call s:hi("Comment", "NONE", s:overlay0, "NONE", "NONE", "NONE")
call s:hi("Constant", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Identifier", "NONE", s:flamingo, "NONE", "NONE", "NONE")
call s:hi("Statement", "NONE", s:mauve, "NONE", "NONE", "NONE")
call s:hi("PreProc", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Type", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Special", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Underlined", "NONE", s:text, s:base, "underline", "underline")
call s:hi("Error", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Todo", "NONE", s:base, s:flamingo, "bold", "bold")
call s:hi("String", "NONE", s:green, "NONE", "NONE", "NONE")
call s:hi("Character", "NONE", s:teal, "NONE", "NONE", "NONE")
call s:hi("Number", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Boolean", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Float", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Function", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Conditional", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Repeat", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Label", "NONE", s:peach, "NONE", "NONE", "NONE")
call s:hi("Operator", "NONE", s:sky, "NONE", "NONE", "NONE")
call s:hi("Keyword", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Include", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("StorageClass", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Structure", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Typedef", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("debugPC", "NONE", "NONE", s:crust, "NONE", "NONE")
call s:hi("debugBreakpoint", "NONE", s:overlay0, s:base, "NONE", "NONE")

hi link Define Special
hi link Macro PreProc
hi link PreCondit PreProc
hi link SpecialChar Special
hi link Tag Special
hi link Delimiter Special
hi link SpecialComment Special
hi link Debug Special
hi link Exception Error
hi link StatusLineTerm StatusLine
hi link StatusLineTermNC StatusLineNC
hi link Terminal Normal
hi link Ignore Comment

let g:terminal_ansi_colors = [
  \ s:surface1, s:red, s:green, s:yellow, s:blue, s:pink, s:teal, s:subtext1,
  \ s:surface2, s:red, s:green, s:yellow, s:blue, s:pink, s:teal, s:subtext0
\ ]

" ======================================================================
" IN-EDITOR DOCUMENTATION SEARCH (VIA CHT.SH)
" ======================================================================

" Maps Vim's internal filetypes to cht.sh URL endpoints
function! s:get_doc_lang() abort
  let l:lang = &filetype
  if l:lang ==# 'javascriptreact' || l:lang ==# 'typescriptreact'
    return 'react'
  elseif l:lang ==# 'javascript'
    return 'js'
  elseif l:lang ==# 'typescript'
    return 'ts'
  endif
  return l:lang
endfunction

function! s:fetch_docs(lang, query) abort
  if !executable('curl')
    echohl ErrorMsg | echom "Curl is required to fetch docs." | echohl None
    return
  endif

  redraw | echo "Fetching docs for " . a:lang . "..."
  
  let l:query_safe = substitute(a:query, ' ', '+', 'g')
  let l:cmd = 'curl -s ' . shellescape('cht.sh/' . a:lang . '/' . l:query_safe . '?T')
  let l:output = system(l:cmd)

  " Catch 404s, Unknown topics, and 500/HTML server crashes from cht.sh
  if v:shell_error != 0 || l:output =~# 'Unknown topic' || l:output =~# '404 Not Found' || l:output =~? '500 Internal Server Error' || l:output =~? '<html'
    redraw
    echohl WarningMsg 
    echom "cht.sh: No docs found or server overloaded for '" . a:query . "' (" . a:lang . ")" 
    echohl None
    return
  endif

  tabnew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, split(l:output, "\n"))
  normal! gg
  
  try | execute 'setlocal filetype=' . a:lang | catch | endtry

  nnoremap <buffer> <silent> q :tabclose<CR>
  redraw | echo "" 
endfunction

" Prompts for query, but auto-fills the language based on current buffer
function! s:manual_doc_search() abort
  let l:default_lang = s:get_doc_lang()
  
  let l:lang = input('Language: ', l:default_lang)
  if empty(l:lang) | redraw | return | endif
  
  let l:query = input('Query for ' . l:lang . ': ')
  if empty(l:query) | redraw | return | endif
  
  call s:fetch_docs(l:lang, l:query)
endfunction

" Instantly searches the word under cursor using the current buffer's language
function! s:cursor_doc_search() abort
  let l:lang = s:get_doc_lang()
  let l:word = expand('<cword>')
  
  if empty(l:lang) || empty(l:word) 
    echom "No valid filetype or word found."
    return 
  endif
  
  call s:fetch_docs(l:lang, l:word)
endfunction

nnoremap <leader>ds :call <SID>manual_doc_search()<CR>
nnoremap <leader>dw :call <SID>cursor_doc_search()<CR>

let g:autoformat_enabled = 1

function! s:format_buffer() abort
  if !g:autoformat_enabled
    return
  endif

  let l:ft = &filetype
  let l:cmd = ''
  let l:ext = ''

  if l:ft ==# 'python'
    if !executable('ruff')
      return
    endif
    let l:cmd = 'ruff format '
    let l:ext = '.py'
  elseif l:ft ==# 'javascript' || l:ft ==# 'typescript' || l:ft ==# 'javascriptreact' || l:ft ==# 'typescriptreact' || l:ft ==# 'json' || l:ft ==# 'jsonc'
    if !executable('biome')
      return
    endif
    let l:cmd = 'biome format --write '
    let l:ext = l:ft ==# 'javascriptreact' ? '.jsx' :
              \ l:ft ==# 'typescriptreact' ? '.tsx' :
              \ l:ft ==# 'typescript' ? '.ts' :
              \ '.' . l:ft
  elseif l:ft ==# 'go'
    if !executable('gofmt')
      return
    endif
    let l:cmd = 'gofmt -w '
    let l:ext = '.go'
  elseif l:ft ==# 'rust'
    if !executable('rustfmt')
      return
    endif
    let l:cmd = 'rustfmt '
    let l:ext = '.rs'
  elseif l:ft ==# 'lua'
    if !executable('stylua')
      return
    endif
    let l:cmd = 'stylua '
    let l:ext = '.lua'
  else
    return
  endif

  let l:view = winsaveview()
  let l:tmp = tempname() . l:ext
  call writefile(getline(1, '$'), l:tmp)

  let l:output = system(l:cmd . shellescape(l:tmp))

  if v:shell_error == 0
    let l:formatted = readfile(l:tmp)
    if getline(1, '$') != l:formatted
      silent %delete _
      call setline(1, l:formatted)
    endif
  else
    let l:errlines = split(l:output, "\n")
    redraw | echohl ErrorMsg
    for l:line in l:errlines[0:4]
      echom l:line
    endfor
    echohl None
  endif

  call delete(l:tmp)
  call winrestview(l:view)
endfunction

command! ToggleAutoFormat let g:autoformat_enabled = !g:autoformat_enabled

augroup AutoFormat
  autocmd!
  autocmd BufWritePre *.css,*.py,*.js,*.ts,*.jsx,*.tsx,*.json,*.jsonc,*.go,*.rs,*.lua call s:format_buffer()
augroup END

nnoremap <leader>fm :call <SID>format_buffer()<CR>
" CURSOR SHAPES (Neovim Behavior)
" Send raw escape sequences to the terminal to change cursor shape:
" 1 or 2 = Solid Block (Normal mode)
" 3 or 4 = Solid Underline (Replace mode)
" 5 or 6 = Solid Vertical Bar (Insert mode)

let &t_SI = "\e[6 q" " Thin vertical bar when typing
let &t_EI = "\e[2 q" " Thick block when not typing
let &t_SR = "\e[4 q" " Underline in replace mode
" Use these instead if you run Vim inside Tmux
if exists('$TMUX')
  let &t_SI = "\ePtmux;\e\e[6 q\e\\"
  let &t_EI = "\ePtmux;\e\e[2 q\e\\"
  let &t_SR = "\ePtmux;\e\e[4 q\e\\"
endif

let &fillchars .= ',eob: '

function! s:minioil() abort
  let l:dir = expand('%:p:h')
  if empty(l:dir) | let l:dir = getcwd() | endif
  
  " Grab all visible and hidden files (excluding . and ..)
  let l:paths = split(globpath(l:dir, '*'), '\n') + split(globpath(l:dir, '.*'), '\n')
  let l:files = []
  for l:p in l:paths
    let l:name = fnamemodify(l:p, ':t')
    if l:name !=# '.' && l:name !=# '..'
      call add(l:files, l:name)
    endif
  endfor
  let l:files = uniq(sort(l:files))

  " Open a clean, temporary tab
  tabnew
  setlocal buftype=acwrite bufhidden=wipe noswapfile
  let b:minioil_dir = l:dir
  let b:minioil_orig = l:files
  
  let l:lines = [
    \ "# MINI-OIL: Edit the names on the RIGHT side of the '->' arrow.",
    \ "# Delete a line completely to delete the file.",
    \ "# Save (:w) to apply your changes. Press 'q' to abort.",
    \ ""
    \ ]
  for l:f in l:files
    call add(l:lines, l:f . '  ->  ' . l:f)
  endfor

  call setline(1, l:lines)
  
  " Hook the save command to our apply function
  autocmd BufWriteCmd <buffer> call s:minioil_apply()
  nnoremap <buffer> <silent> q :tabclose<CR>
  
  " Make it pretty
  syntax match Comment "^#.*"
  syntax match Special "  ->  "
endfunction

function! s:minioil_apply() abort
  let l:dir = b:minioil_dir
  let l:orig = b:minioil_orig
  let l:lines = getline(1, '$')
  
  let l:to_keep = {}
  let l:to_rename = {}

  " Parse the buffer
  for l:line in l:lines
    if l:line =~# '^\s*#' || empty(l:line) | continue | endif
    let l:parts = split(l:line, '  ->  ')
    if len(l:parts) >= 2
      let l:old = trim(l:parts[0])
      let l:new = trim(l:parts[1])
      let l:to_keep[l:old] = 1
      if l:old !=# l:new
        let l:to_rename[l:old] = l:new
      endif
    endif
  endfor

  " 1. Process Deletions safely (prompts for confirmation to prevent accidents)
  for l:old in l:orig
    if !has_key(l:to_keep, l:old)
      let l:path = l:dir . '/' . l:old
      if confirm("Delete '" . l:old . "'?", "&Yes\n&No", 2) == 1
        if isdirectory(l:path)
          call delete(l:path, 'd')
        else
          call delete(l:path)
        endif
        echom "Deleted: " . l:old
      endif
    endif
  endfor

  " 2. Process Renames
  for [l:old, l:new] in items(l:to_rename)
    let l:oldpath = l:dir . '/' . l:old
    let l:newpath = l:dir . '/' . l:new
    if rename(l:oldpath, l:newpath) == 0
      echom "Renamed: " . l:old . " -> " . l:new
    else
      echohl ErrorMsg | echom "Failed to rename: " . l:old | echohl None
    endif
  endfor

  " Close the scratch buffer and report success
  setlocal nomodified
  tabclose
  redraw | echo "Mini-Oil: Filesystem updated."
endfunction

function! s:minioil() abort
  let l:dir = expand('%:p:h')
  if empty(l:dir) | let l:dir = getcwd() | endif

  let l:paths = split(globpath(l:dir, '*'), '\n') + split(globpath(l:dir, '.*'), '\n')
  let l:files = []
  for l:p in l:paths
    let l:name = fnamemodify(l:p, ':t')
    if l:name !=# '.' && l:name !=# '..'
      " trailing slash flags directories for the create-path
      call add(l:files, isdirectory(l:p) ? l:name . '/' : l:name)
    endif
  endfor
  let l:files = uniq(sort(l:files))

  tabnew
  setlocal buftype=acwrite bufhidden=wipe noswapfile filetype=minioil
  let b:minioil_dir = l:dir
  let b:minioil_orig = l:files

  let l:lines = [
    \ "# MINI-OIL: Edit the names on the RIGHT side of the '->' arrow.",
    \ "# Delete a line completely to delete the file/directory.",
    \ "# Add a new line 'name  ->  name' to create a file. Trailing '/' creates a directory.",
    \ "# Save (:w) to apply your changes. Press 'q' to abort.",
    \ ""
    \ ]
  for l:f in l:files
    call add(l:lines, l:f . '  ->  ' . l:f)
  endfor
  call setline(1, l:lines)

  autocmd BufWriteCmd <buffer> call s:minioil_apply()
  nnoremap <buffer> <silent> q :tabclose<CR>

  syntax match Comment "^#.*"
  syntax match Special "  ->  "
endfunction

function! s:minioil_apply() abort
  let l:dir = b:minioil_dir
  let l:orig = b:minioil_orig
  let l:lines = getline(1, '$')

  let l:to_keep = {}
  let l:to_rename = {}

  for l:line in l:lines
    if l:line =~# '^\s*#' || empty(trim(l:line)) | continue | endif
    let l:parts = split(l:line, '  ->  ')
    if len(l:parts) >= 2
      let l:old = trim(l:parts[0])
      let l:new = trim(join(l:parts[1:], '  ->  '))
      let l:to_keep[l:old] = 1
      if l:old !=# l:new
        let l:to_rename[l:old] = l:new
      endif
    endif
  endfor

  " 1. Gather deletions and confirm as a single batch
  let l:to_delete = []
  for l:old in l:orig
    if !has_key(l:to_keep, l:old)
      call add(l:to_delete, l:old)
    endif
  endfor

  if !empty(l:to_delete)
    let l:msg = "Delete the following?\n" . join(l:to_delete, "\n")
    if confirm(l:msg, "&Yes\n&No", 2) != 1
      setlocal nomodified
      redraw | echo "Mini-Oil: Aborted, no changes made."
      return
    endif
  endif

  " 2. Process deletions (recursive for non-empty dirs, error checked)
  for l:old in l:to_delete
    let l:name = substitute(l:old, '/$', '', '')
    let l:path = l:dir . '/' . l:name
    if isdirectory(l:path)
      if delete(l:path, 'rf') != 0
        echohl ErrorMsg | echom "Failed to delete directory: " . l:old | echohl None
        continue
      endif
    else
      if delete(l:path) != 0
        echohl ErrorMsg | echom "Failed to delete: " . l:old | echohl None
        continue
      endif
    endif
    echom "Deleted: " . l:old
  endfor

  " 3. Process renames in two passes to avoid collisions/swaps/chains
  let l:tmp_renames = {}
  for [l:old, l:new] in items(l:to_rename)
    let l:oldname = substitute(l:old, '/$', '', '')
    let l:newname = substitute(l:new, '/$', '', '')
    let l:oldpath = l:dir . '/' . l:oldname
    let l:tmpname = l:newname . '.minioil_tmp_' . reltimestr(reltime())
    let l:tmppath = l:dir . '/' . l:tmpname
    if rename(l:oldpath, l:tmppath) == 0
      let l:tmp_renames[l:tmpname] = l:newname
    else
      echohl ErrorMsg | echom "Failed to rename: " . l:old | echohl None
    endif
  endfor
  for [l:tmpname, l:newname] in items(l:tmp_renames)
    let l:tmppath = l:dir . '/' . l:tmpname
    let l:newpath = l:dir . '/' . l:newname
    if rename(l:tmppath, l:newpath) == 0
      echom "Renamed: " . l:newname
    else
      echohl ErrorMsg | echom "Failed to rename to: " . l:newname | echohl None
    endif
  endfor

  " 4. Process new entries (lines where old == new, not present originally)
  for l:old in keys(l:to_keep)
    if index(l:orig, l:old) == -1 && !has_key(l:to_rename, l:old)
      let l:path = l:dir . '/' . substitute(l:old, '/$', '', '')
      if l:old =~# '/$'
        if !isdirectory(l:path)
          call mkdir(l:path, 'p')
          echom "Created directory: " . l:old
        endif
      else
        if !filereadable(l:path) && !isdirectory(l:path)
          call writefile([], l:path)
          echom "Created: " . l:old
        endif
      endif
    endif
  endfor

  setlocal nomodified
  tabclose
  redraw | echo "Mini-Oil: Filesystem updated."
endfunction

" nnoremap <leader>e :call <SID>minioil()<CR>

function! s:toggle_comment(line1, line2) abort
  " Fallback to standard hash if the filetype plugin didn't set a string
  let l:cms = empty(&commentstring) ? '# %s' : &commentstring
  let l:parts = split(l:cms, '%s', 1)
  
  " Extract the left and right sides of the comment string
  let l:left = trim(l:parts[0])
  let l:right = len(l:parts) > 1 ? trim(l:parts[1]) : ''

  for l:lnum in range(a:line1, a:line2)
    let l:line = getline(l:lnum)
    if empty(l:line) | continue | endif

    " Preserve exact indentation
    let l:indent = matchstr(l:line, '^\s*')
    let l:content = substitute(l:line, '^\s*', '', '')

    " Safely escape comment characters for regex matching
    let l:esc_left = escape(l:left, '/*\^$.~[]')
    let l:esc_right = escape(l:right, '/*\^$.~[]')

    " Check if the line is already commented
    let l:is_commented = 0
    if l:content =~# '^' . l:esc_left
      if empty(l:right) || l:content =~# l:esc_right . '$'
        let l:is_commented = 1
      endif
    endif

    if l:is_commented
      " UNCOMMENT: Strip the comment characters and exactly 1 space
      let l:new_content = substitute(l:content, '^' . l:esc_left . '\s\?', '', '')
      if !empty(l:right)
        let l:new_content = substitute(l:new_content, '\s\?' . l:esc_right . '$', '', '')
      endif
      call setline(l:lnum, l:indent . l:new_content)
    else
      " COMMENT: Wrap the content and add spaces for readability
      let l:new_content = l:left . ' ' . l:content
      if !empty(l:right)
        let l:new_content .= ' ' . l:right
      endif
      call setline(l:lnum, l:indent . l:new_content)
    endif
  endfor
endfunction
" Toggle comment on current line (Normal mode)
nnoremap gc :call <SID>toggle_comment(line('.'), line('.'))<CR>

" Toggle comment on visually selected lines (Visual mode)
vnoremap gc :call <SID>toggle_comment(line("'<"), line("'>"))<CR>
