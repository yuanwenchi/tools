"========================normal config======================
set so=7              "Scroll when cursor is 7 lines from top/bottom of screen
set hlsearch          "search highlight
set tabstop=4         "tab have 4 char
set shiftwidth=4      "shift length
set softtabstop=4
set nu                "show line number
set showcmd           "show command
set showmatch         "show match sign
set cursorline        "highlight cursor line
syntax enable         "syntax highlight
syntax on
"fast create tags project at current fold
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR> 
"vector screen
map <leader>v :vsp 
"horizontal screen
map <leader>s :sp 
"16 format
map <leader>x :%!xxd 
"auto entry current dir
set autochdir
"Use Tab instead of Ctr+w to switch window"
nnoremap <Tab> <C-W>w
set nocompatible   " Disable vi-compatibility
set encoding=utf8
set t_Co=256
" leader key is \
let mapleader = "\\"
"-----------------------------------------------------------

" ==================== colorscheme =========================
"set background=dark
colorscheme molokai
"colorscheme solarized
"-----------------------------------------------------------

"================== keep cursor position when exit =================
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
"-----------------------------------------------------------

"==============cmake=================
"compile by makefile 
map <leader>cc :make <CR>
"compile by customize command. e.g gcc\ -Wall\ -ohello\ hello.c
map <leader>ca :set makeprg=
"compile window occupy the full width at the bottom of the screen.
map <leader>c<space> :botright cwindow <CR>
"------------------------------------

" ================== vim-powerline config ==================
let g:Powerline_symbols = 'unicode'
"let g:Powerline_stl_path_style = 'full'          "display full path
let g:Powerline_cache_enabled = 0
let g:Powerline_cache_dir = simplify(expand('<sfile>:p:h') .'/..')
"-----------------------------------------------------------

"=====================Fuzzyfinder===========================
map <leader>f :FufFile<CR>
map <leader>G :FufTaggedFile<CR>
map <leader>t :FufTag<CR>
map <leader>b :FufBuffer<CR>
map <leader>l :FufMruFile<CR>
let g:fuf_modesDisable = []
"-----------------------------------------------------------

"=====================EasyMotion============================
let g:EasyMotion_leader_key = ']'
let g:EasyMotion_smartcase=1
"double-char search
nmap s <Plug>(easymotion-s2)
"----------------------------------------------------------

"===================== NERD tree ===========================
let g:NERDTreeWinPos = "right"
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
"-----------------------------------------------------------

"====================Tagbar==========================
"help :
"	In tagbar window:
"		P - open preview window
"		Space - show function 
"auto open tagbar
autocmd VimEnter * nested :call tagbar#autoopen(1)
"auto open preview
"let g:tagbar_autopreview = 1
let g:tagbar_previewwin_pos = "aboveleft"
"disable preview line number
autocmd BufWinEnter * if &previewwindow | setlocal nonumber | endif
let g:tagbar_autoshowtag = 1
let g:tagbar_width = 35 "default value is 40
let g:tagbar_left = 1
nmap <F8> :TagbarToggle<CR>
"-----------------------------------------------------------

"==================OmniCppComplete =========================
"let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表 
"let OmniCpp_MayCompleteDot = 1   " 输入 .  后自动补全
"let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全 
"let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全 
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"] " 自动关闭补全窗口 
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif " 自动关闭补全窗口
"set completeopt=menuone,menu,longest
"-----------------------------------------------------------

"==============javacomplete=================================
"autocmd Filetype java setlocal omnifunc=javacomplete#Complete
setlocal omnifunc=javacomplete#Complete
setlocal completefunc=javacomplete#CompleteParamsInfo 
autocmd Filetype java,javascript,jsp inoremap <buffer>  .  .<C-X><C-O><C-P>
"You can map as follows for better display: 
inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P> 
inoremap <buffer> <C-S-Space> <C-X><C-U><C-P> 
"-----------------------------------------------------------

"================== snipmate ===============================
let g:snipMate = { 'snippet_version' : 1 }
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['ruby'] = 'ruby,rails'
"-----------------------------------------------------------

"==================cscope project===========================
"使用folder name匹配cscope与code , 匹配两层目录的名字，两层目录可以不连续
function GetAbsPath(path)
	let s:path=getcwd()
	return substitute(a:path, '^[^/]', s:path . '/&', 'g')
endfunction

function SearchPorjCS()
	let s:path=GetAbsPath(argv(0))
	let s:flst=system('ls ' . $HOME . '/cscope_proj')
	let s:fname=""
	let s:fname1=""
	let s:yuan=""
	for s:temp in split(s:flst)
	let s:fname=matchstr(s:path,s:temp)
	if s:fname != ""
		let s:flst=system('ls ' . $HOME . '/cscope_proj/' . s:fname)
		for s:temp in split(s:flst)
			let s:fname1=matchstr(s:path,s:temp)
			if s:fname1 != ""
				"如果有这个cscope工程,使用该工程的ctags
				exec ':set tags=' . $HOME . '/cscope_proj/' . s:fname . '/' .  s:fname1 . '/tags'
				exec ':cs add ' . $HOME . '/cscope_proj/' . s:fname . '/' . s:fname1
				break
			endif
		endfor
		break
	endif
endfor
endfunction

"Cscope automatically load files, step by step to find the current directory to the parent directory
function! AutoLoadCTagsAndCScope()
    let max = 8
	let dir = './'
"    let dir = getcwd()
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'cscope.out') 
            execute 'cs add ' . dir . 'cscope.out'
            let break = 1
        endif
        if filereadable(dir . 'tags')
            execute 'set tags =' . dir . 'tags'
            let break = 1
        endif
        if break == 1
            execute 'lcd ' . dir
            break
        endif
        let dir = dir . '../'
        let i = i + 1
    endwhile
endf

nmap <F9> :call AutoLoadCTagsAndCScope()<CR>

if has("cscope")
	if ! filereadable("cscope.out")
		call SearchPorjCS()
	endif
endif
"-----------------------------------------------------------

" ===============Vundle config================
set nocompatible              " be iMproved
filetype off                  " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" 
" My Bundles here:
"
" You can use four mode to add plus across below
" a)指定Github中vim-scripts仓库中的插件，直接指定插件名称即可，插件明中的空格使用“-”代替。
" a) plugin from http://vim-scripts.org/vim/scripts.html
Bundle 'L9'
Bundle 'The-NERD-tree'
"auto completion function base on check language by itself
Bundle 'AutoComplPop'
Bundle 'cscope_macros.vim'
Bundle 'OmniCppComplete'
Bundle 'javacomplete'
Bundle 'JSON.vim'

" b) 指定Github中其他用户仓库的插件，使用“用户名/插件名称”的方式指定
" b) plugin on GitHub repo (username/plugin)
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline.git'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
"Bundle 'FuzzyFinder'
"FuzzyFinder stop maintaining. The project clone from FuzzyFinder and fix bug
Bundle 'yuanwenchi/FuzzyFinder'
Bundle 'yuanwenchi/vim-markdown-pandoc'
Bundle 'aklt/plantuml-syntax'
Bundle 'majutsushi/tagbar'

" Color schemes
Plugin 'tomasr/molokai'
Plugin 'flazz/vim-colorschemes'

"snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'Yggdroot/LeaderF'
" Optional:
Plugin 'honza/vim-snippets'

" c) 指定非Github的Git仓库的插件，需要使用git地址
"Bundle 'git://git.wincent.com/command-t.git'
"Bundle 'http://github.com/Lokaltog/vim-powerline.git'

" d) 指定本地Git仓库中的插件
"Bundle 'file:///Users/gmarik/path/to/plugin'

filetype plugin indent on     " required!
"-----------------------------------------------------------
