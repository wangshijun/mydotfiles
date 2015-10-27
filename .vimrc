" General {
    set nocompatible
    set laststatus=2

    set mouse=v                 " automatically enable mouse usage
    set mousehide               " hide the mouse cursor while typing
    scriptencoding utf-8
    set encoding=utf-8 nobomb

    if has ('x') && has ('gui') " on Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui') " one mac and windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    " set autowrite                  " automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=1000                " Store a ton of history (default is 20)
    " set spell                       " spell checking on
    set hidden                      " allow buffer switching without saving

    " Setting up the directories {
    set backup                      " backups are nice ...
    " Centralize backups, swapfiles and undo history
    set backupdir=~/.vim/backups
    set directory=~/.vim/swaps
    if exists("&undodir")
        set undodir=~/.vim/undo
    endif
    if has('persistent_undo')
        set undofile                "so is persistent undo ...
        set undolevels=1000         "maximum number of changes that can be undone
        set undoreload=10000        "maximum number lines to save for undo on a buffer reload
    endif
" }

" Vim UI {
    set tabpagemax=15               " only show 15 tabs
    set showmode                    " display the current mode
    set cursorline                  " highlight current line

    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    " Use relative line numbers
    if exists("&relativenumber")
        set relativenumber
        au BufReadPost * set relativenumber
    endif

    set backspace=indent,eol,start  " backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " show matching brackets/parenthesis
    set incsearch                   " find as you type search
    set hlsearch                    " highlight search terms
    set winminheight=0              " windows can be 0 line high
    set ignorecase                  " case insensitive search
    set smartcase                   " case sensitive when uc present
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set scrolljump=5                " lines to scroll when cursor leaves screen
    set scrolloff=3                 " minimum lines to keep above and below cursor
    set foldenable                  " auto fold code
    set list
    set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
    set iskeyword+=-                " - as part of a word

" }

" Formatting {
    set wrap                      " wrap long lines
    set autoindent                  " indent at the same level of the previous line
    set shiftwidth=4                " use indents of 4 spaces
    set expandtab                   " tabs are spaces, not tabs
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
    "set matchpairs+=<:>                " match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " autocmd FileType c,cpp,java,php,javascript,python,twig,xml,yml,css,js,html autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    " autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    " Automatic commands
    if has("autocmd")
        " Enable file type detection
        filetype on
        " Treat .json files as .js
        autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    endif
" }

" Key (re)Mappings {

    let mapleader = ','

    " Strip trailing whitespace (,ss)
    function! StripWhitespace()
        let save_cursor = getpos(".")
        let old_query = getreg('/')
        :%s/\s\+$//e
        call setpos('.', save_cursor)
        call setreg('/', old_query)
    endfunction
    noremap <leader>ss :call StripWhitespace()<CR>
    " Save a file as root (,W)
    noremap <leader>W :w !sudo tee % > /dev/null<CR>

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " Stupid shift key fixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe
    cmap Tabm tabm
    cmap Tabo tabo

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    """ Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " tabprevious/next
    nmap <C-N> :tabnext<CR>
    nmap <C-P> :tabprevious<CR>

    " Disable arrow keys
    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>
    imap <up> <nop>
    imap <down> <nop>
    imap <left> <nop>
    imap <right> <nop>

    " insert mode shortcut
    inoremap <C-h> <Left>
    inoremap <C-j> <Down>
    inoremap <C-k> <Up>
    inoremap <C-l> <Right>
    inoremap <C-d> <DELETE>
" }

" Plugins {

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Steve Francia <steve.francia@gmail.com>'
    " }

     " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
     "}

" }

" GUI Settings {
    syntax on
    filetype plugin indent on   " Automatically detect file types.

    set background=dark
    set t_Co=256                 " Enable 256 colors to stop the CSApprox warning and make xterm vim shine

    let g:solarized_termtrans=1
    let g:solarized_contrast="high"
    let g:solarized_visibility="high"
    let g:solarized_termcolors=256
    colorscheme solarized

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guifont=Menlo:h18       " Use 18pt Menbo
        set guioptions-=T           " remove the toolbar
        set linespace=2             " Better line-height
        set lines=40                " 40 lines of text instead of 24,
        if has('gui_macvim')
            set transparency=5          " Make the window slightly transparent
        endif
    endif

    execute pathogen#infect()

    " airline Settings
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1

    " tab styles
    set showtabline=2
    hi TabLineFill ctermfg=LightGreen ctermbg=235
    hi TabLine ctermfg=245 ctermbg=236
    hi TabLineSel ctermfg=254 ctermbg=24

" }

" Use local vimrc if available {
    if filereadable(expand("$HOME/.vimrc.local"))
        source $HOME/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("$HOME/.gvimrc.local"))
            source $HOME/.gvimrc.local
        endif
    endif
" }
