" taken from https://www.circuidipity.com/neovim/

set nocompatible            " Disable compatibility to old-time vi
set showmatch               " Show matching brackets.
set ignorecase              " Do case insensitive matching
set smartcase               " Do case-sensitive matching IF there's an uppercase
set mouse=a                 " Enable mouse usage (all modes)
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set relativenumber          " show line number relatively to current
set wildmode=longest,list   " get bash-like tab completions
set cc=80                   " set an 80 column border for good coding style
set wrap                    " automatic wrap
set tw=80                   " autowrap at border
set gdefault                " search automatically global
set updatetime=100          " delay of update = 100ms
set background=dark         " Setting dark mode
set inccommand=nosplit      " highlight search in :s command

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim

call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'           " let Vundle manage Vundle, required
Plugin 'airblade/vim-gitgutter'         " displays a git diff column
Plugin 'vimwiki/vimwiki'                " Personal Wiki plugin
Plugin 'vim-airline/vim-airline'        " Enhanced statusline
Plugin 'vim-airline/vim-airline-themes' " themes
Plugin 'morhetz/gruvbox'                " global theme
Plugin 'majutsushi/tagbar'              " class outline viewer
Plugin 'Yggdroot/indentLine'            " Show algorithm-like lines
Plugin 'Tabular'                        " To automatically align text
Plugin 'davidhalter/jedi-vim'           " jedi for python
Plugin 'w0rp/ale'                       " python linters
Plugin 'ncm2/ncm2'                      " awesome autocomplete plugin
Plugin 'roxma/nvim-yarp'                " dependency of ncm2
Plugin 'HansPinckaers/ncm2-jedi'        " fast python completion 
Plugin 'ncm2/ncm2-bufword'              " buffer keyword completion
Plugin 'ncm2/ncm2-path'                 " filepath completion
Plugin 'roxma/vim-hug-neovim-rpc'       " required for ?
Plugin 'Shougo/neosnippet.vim'          " snippets tool
Plugin 'Shougo/neosnippet-snippets'     " basic snippets
Plugin 'ncm2/ncm2-neosnippet'           " integration with ncm2
Plugin 'Chiel92/vim-autoformat'         " Formater
Plugin 'lervag/vimtex'                  " vimtex lol
Plugin 'scrooloose/nerdtree'            " to see files
Plugin 'mattn/calendar-vim'             " vim calendar
Plugin 'wfxr/minimap.vim'               " show minimap
Plugin 'python-mode/python-mode'        " for python mode mdr
Plugin 'tpope/vim-fugitive'             " awesome git inclusion
Plugin 'machakann/vim-highlightedyank'  " show what's been yanked

call vundle#end()            " All of your Plugins must be added before

filetype plugin indent on    " allows auto-indenting depending on file type
syntax on
syntax enable

" Set leader as space, first removing its attributes
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

" Get here and source this
nnoremap <silent> <leader>ec :e $MYVIMRC<CR>
nnoremap <silent> <leader>sc :source $MYVIMRC<CR>

" Python shortcut
nnoremap <F12> :exec '!python3' shellescape(@%, 1)<cr>

" VimWikiSearch made easy
" nnoremap § :VWS /
" Après :VWS / /, naviguer les recherches
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lp :lnext<CR>
nnoremap <leader>ln :lprevious<CR>
" Créer une ligne au-dessus et en-dessous
nnoremap <leader>o o<Esc>O
" Aller en bas du texte, l'aligner au milieu de la fenêtre, et écrire au bout
nnoremap § GzzA
" justify text
nnoremap <leader>g mzgqip`z
" toggle highlight
nnoremap <leader>h :noh<CR>

noremap <F3> :Autoformat<CR>
" Toggle Spelling
" ]s and [s to move, zg if good, z= for suggestion, zw if wrong
nnoremap <leader>se :set spelllang=en_us<CR>
nnoremap <leader>sf :set spelllang=fr<CR>
nnoremap <leader>ss :set invspell<CR>

" toggle tagbar
nnoremap <silent> <leader>tb :TagbarToggle<CR>

" Change all regex to magic regex
nnoremap / /\v
vnoremap / /\v
nnoremap :%s! :%smagic!\v
nnoremap :g/ :g/\v
nnoremap :g// :g//

" buffer commands
nnoremap <silent> <leader>bb <C-^> 
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <silent> <leader>bd :bd<CR>
nnoremap <silent> <leader>bk :bd!<CR>

" tabs:
nnoremap <leader>tn :tabnew<Space>
nnoremap <leader>hh :tabprev<CR>
nnoremap <leader>k  :tabfirst<CR>
nnoremap <leader>j  :tablast<CR>
nnoremap <leader>ll :tabnext<CR>

" Easy quit, save, savequit
nnoremap <leader>q :q<CR>
nnoremap <leader>sq :qa<CR>
nnoremap <leader><space> :w<cr>
nnoremap <leader>x :wq<CR>

" Copy to clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" " disable normal use of <C-j> and <C-k> to rebind them
" let g:BASH_Ctrl_j = 'off'
" let g:BASH_Ctrl_k = 'off'
" let g:C_Ctrl_j = 'off'
" let g:C_Ctrl_k = 'off'
" :imap <C-=> <Plug>VimwikiListNextSymbol
" :imap <C-)> <Plug>VimwikiListPrevSymbol

" augroup vimrc
"     au!
"     au VimEnter * unmap <C-j>
"     au VimEnter * nnoremap <C-j> <C-w>j
" augroup END

" easy (split) movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>V <C-w>v<C-w>l
nnoremap <leader>S <C-w>s<C-w>k

" easy resize movement
nnoremap <silent> <leader>< <C-w>2<
nnoremap <silent> <leader>> <C-w>2>
nnoremap <silent> <leader>+ <C-w>2+
nnoremap <silent> <leader>- <C-w>2-

" move one line up or down
nnoremap <A-j> <C-E>
nnoremap <A-k> <C-Y>

" Align stuff
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>

" jedi options
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#documentation_command = "<leader>x"
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
" let g:jedi#completions_command = <S-Tab>
let g:jedi#show_call_signatures = "1"
let g:jedi#show_call_signatures_delay = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures_modes = 'i'  " ni = also in normal mode
let g:jedi#enable_speed_debugging=0

" NCM2
augroup NCM2
  autocmd!
  " enable ncm2 for all buffers
  autocmd BufEnter * call ncm2#enable_for_buffer()
  
  " :help Ncm2PopupOpen for more information
  set completeopt=noinsert,menuone,noselect
  
  " When the <Enter> key is pressed while the popup menu is visible, it only
  " hides the menu. Use this mapping to close the menu and also start a new line
  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
  
  " Use <A-TAB> to select the popup menu:
  inoremap <expr> <A-a> pumvisible() ? "\<C-n>" : "\<A-a>"
  inoremap <expr> <A-z> pumvisible() ? "\<C-p>" : "\<A-z>"
  
  " uncomment this block if you use vimtex for LaTeX
   autocmd Filetype tex call ncm2#register_source({
             \ 'name': 'vimtex',
             \ 'priority': 8,
             \ 'scope': ['tex'],
             \ 'mark': 'tex',
             \ 'word_pattern': '\w+',
             \ 'complete_pattern': g:vimtex#re#ncm2,
             \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
             \ })
augroup END

" make it FAST
let ncm2#popup_delay = 1
let ncm2#complete_length = [[1,1]]
let g:ncm2#matcher = 'substrfuzzy'

" When pressing <C-k> in insert or select mode, be smart about snippet
" expansion/jumping no matter the state
imap <expr><A-e> ExpandOrJumpSnippet()
smap <expr><A-e> ExpandOrJumpSnippet()
xmap <A-e>     <Plug>(neosnippet_expand_target)

" For conceal markers.
if has('conceal')
  set conceallevel=0 concealcursor=niv
endif

" neosnippet key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" imap <Tab>     <Plug>(neosnippet_expand_or_jump)
" smap <Tab>     <Plug>(neosnippet_expand_or_jump)
" xmap <Tab>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
" imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

func! ExpandOrJumpSnippet()
  " Expand a snippet if at all possible.
  "
  " There are a few possibilities:
  " * ncm2 autocomplete is being used and a snippet item is currently
  " selected.  In that case expand that snippet.  Note that ncm2 exposes some
  " snippets beyond those neosnippet knows about, even though it uses
  " neosnippet to expand them.  These are "anonymous" snippets like the ones
  " it gets from an LSP.  Thus if ncm2 has been used to pick a snippet it's
  " important to use ncm2's neosnippet API to do the completion.  IF it is a
  " built-in neosnippet snippet then it'll call down into neosnippet anyway.
  "
  " * ncm2 is not active, but a neocomplete snippet trigger has been typed.
  " In that case expand the snippet.
  "
  " * a neosnippet snippet has been expanded, and there is another placeholder
  " still to navigate to.  In that case, jump to the next placeholder.
  if ncm2_neosnippet#completed_is_snippet()
    echom "ncm2_neosnippet expanding"
    return "\<Plug>(ncm2_neosnippet_expand_completed)"
  elseif neosnippet#expandable_or_jumpable()
    echom "neosnippet expanding"
    if neosnippet#mappings#expandable()
      echom "snippet expandable"
    endif

    if neosnippet#mappings#jumpable()
      echom "snippet jumpable"
    endif

    echom "completed_item: " . json_encode(v:completed_item)

    return "\<Plug>(neosnippet_expand_or_jump)"
  elseif pumvisible()
    " No kind of snippet but the autocomplete is visible.  Probably I
    " accidentally or out of force of habit hit C-k on an autocomplete item
    " that wasn't actually a snippet.  If that happens just dismiss the
    " autocomplete but stay in insert mode so it doesn't disrupt my workflow
    echom "dismissing popup"
    return "\<C-y>"
  else
    echom "nothing to do; passing through to underlying C-k binding"
    return "\<A-e>"
  endif
endfunction

let g:neosnippet#snippets_directory = '~/.config/nvim/bundle/neosnippet-snippets/neosnippets/'

" NERDTree config
nnoremap <leader>M :NERDTreeToggle<CR>
" Automatically set working directory to the current file's directory
autocmd BufEnter * lcd %:p:h

" Tagbar config
let g:tagbar_width = 28
" Minimap config
nnoremap <leader>mm :MinimapToggle<CR>

" Latex config
let g:tex_flavor  = 'latex'
let g:tex_conceal = ''
let g:vimtex_fold_manual = 1
" Deprecated, basically used I guess?
" let g:vimtex_latexmk_continuous = 1
" Don't format environments
let g:vimtex_format_enabled = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'general'
let g:vimtex_view_general_viewer = 'evince'
nnoremap <leader>vc :VimtexCompile<CR>
nnoremap <leader>vv :VimtexView<CR>
nnoremap <leader>vm :VimtexToggleMain<CR>
" autocmd Filetype tex,latex map <f1> :wa<cr><leader>ll

" vimwiki config
let wiki_1 = {}
let wiki_1.path = '~/Documents/wiki/'
let wiki_1.path_html = '~/Documents/wiki/html'

let wiki_2 = {}
let wiki_2.path = '~/Documents/worki/'
let wiki_2.path_html = '~/Documents/worki/html'
let wiki_2.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'bash'}

let g:vimwiki_list = [wiki_1, wiki_2]
" let g:vimwiki_list = [{'path': '~/Documents/wiki/',
"                       \'path_html': '~/Documents/wiki/html/'}
"                       {'path': '~/Documents/worki/',
"                       \'path_html': '~/Documents/worki/html/'}\]
au BufRead,BufNewFile *.wiki set filetype=vimwiki
:autocmd FileType vimwiki map <leader>d :VimwikiMakeDiaryNote
function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
:autocmd FileType vimwiki map <leader>C :call ToggleCalendar()<CR>

" Change checked list item to grey italic
let g:vimwiki_hl_cb_checked = 1
" allow calendar to be full width
let g:calendar_options = 'nornu'
" pretty much self explanatory lol
let g:calendar_number_of_months = 6
" make calendar start on mondays
let g:calendar_monday = 1

" set the colors of vimwiki syntax.
" type :so $VIMRUNTIME/syntax/hitest.vim
:hi link VimwikiItalic GruvboxBlueBold       "      _ Blue bold _
:hi link VimwikiCode GruvboxAquaBold         "      ` Aqua bold `
:hi link VimwikiBoldItalic GruvboxPurpleBold "     _* Purple bold *_
:hi link VimwikiEqIn Question                "      $ Orange bold $
:hi link VimwikiDelText MoreMsg              "     ~~ Yellow bold ~~
:hi link VimwikiBold WarningMsg              "      * Reddish bold *
:hi link VimwikiLink Directory               "     [[ Green bold ]]
:hi link VimwikiHeader1 GruvboxAquaBold      "      = Aqua bold =
:hi link VimwikiHeader2 GruvboxBlueBold      "     == Blue bold ==
:hi link VimwikiHeader3 GruvboxPurpleBold    "    === Purple bold ===
:hi link VimwikiHeader4 MoreMsg              "   ==== Yellow bold ====
:hi link VimwikiHeader5 Question             "  ===== Orange bold =====
:hi link VimwikiHeader6 WarningMsg           " ====== Reddish Bold ======
:hi link VimwikiTodo GruvboxPurpleBold       " sets « TODO » purple bold

" Ale config
let g:ale_sign_error = '‼'
let g:ale_sign_warning = '∙'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8']}

" vim-airline config
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'

" gruvbox config
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

" path to your python 
let g:python3_host_prog = '/home/nicolas/.installs/anaconda3/bin/python'

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.config/nvim/'
let &runtimepath.=','.vimDir

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" %smagic!\v(\d+(,|)(\d+|)) \\U\{(\w+)\}!\\SI{\1}{\4}
" %smagic!\v\\nb\{(\d+(,|)\d+)\} \\U!\\SI{\1}
" %smagic!\v \ze(:|;|\!|\?)!\~
" g/\\noindent/d
" 
" ÕÏÐË
" éÉ'àèâçùêîôïœû–À
" \\og 
" «~
" \\fg
" ~»
" \\e\ze\{
" \\ind
" \\f\ze\{
" \frac
" varphi
" f
" omega
" w
" sigma
" s
