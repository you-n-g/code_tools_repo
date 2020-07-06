call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go'
Plug 'tomtom/tcomment_vim'
" Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
" Plug 'rdnetto/YCM-Generator'
Plug 'nvie/vim-flake8'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install' }
Plug 'tell-k/vim-autopep8'
" Plug 'python-mode/python-mode', {'branch': 'develop'}
Plug 'tpope/vim-surround'
Plug 'dhruvasagar/vim-table-mode'
" Plug 'mileszs/ack.vim'  # 已经被nvim 替代
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nathanaelkane/vim-indent-guides'

" 这里需要依赖 https://github.com/ryanoasis/nerd-fonts, 需要在本地安装字体
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mhinz/vim-startify'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'liuchengxu/vim-which-key'

Plug 'vim-vdebug/vdebug'   " 等待确认这个插件没有问题,
" 希望这个插件可以代替vscode

" Plug 'wellle/tmux-complete.vim'  #
" 好是好，但是我tmux窗口太多了，会引起性能问题

Plug 'jpalardy/vim-slime' " , { 'for': 'python' } 加上这个之后会导致只对python有用
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }

Plug 'jupyter-vim/jupyter-vim'
Plug 'goerz/jupytext.vim' " `pip install jupytext` is required
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'kshenoy/vim-signature'
Plug 'airblade/vim-gitgutter'

call plug#end()


" settings -------------------------

set ai "auto indent
set expandtab
set tabstop=4
set shiftwidth=4
autocmd FileType c,cpp setlocal shiftwidth=2 tabstop=2
set number
set relativenumber
set scrolloff=10 " always keep 10 lines visible.
set ignorecase
set smartcase

" to automatically load the `.nvimrc`
set exrc
set secure
" examples to ignore
" ignore a directory on top level
" let g:NERDTreeIgnore += ['^models$']
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\vmodels$',
"   \ }
" list.source.grep.excludePatterns 实在是不会用,  所以workaround方法如下
" 就是把那些大文件放到别的地方再Link过来，默认coclist grep不会follow link



" Go to the last cursor location when a file is opened, unless this is a
" git commit (in which case it's annoying)
au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
        \ execute("normal `\"") |
    \ endif
" https://stackoverflow.com/a/774599
" 如果不行一般是因为权限问题: sudo chown user: ~/.viminfo


" highlight current line
set cursorline

" 这个得在前面， 不然会对后面的定义有影响, 配合 vim-which-key
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" Buffer related
" :bd XXX 可以关闭buffer, 关闭buffer，
" c+^ 是可以在最近的两个buffer之间切换的
nnoremap gb :ls<CR>:b<Space>
nnoremap <silent> <Leader>rc  :<C-u>source $MYVIMRC<CR>


" for quick-scope: the color setting must be before the colorscheme
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=107 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=68 cterm=underline
augroup END

let g:gruvbox_contrast_dark="hard"
" let g:gruvbox_contrast_dark="soft"
set background=dark
colorscheme gruvbox

map <F9>p :call CompilePython()<cr>
func! CompilePython()
    exec "w"
    exec "!echo -e '\033[1;34m-----------here\ is\ the\ ans\ of\ %----------\033[0m';python \"%\""
endfunc

map <F9>s :call RunShell()<cr>
func! RunShell()
    exec "w"
    exec "!echo -e '\033[1;34m-----------here\ is\ the\ ans\ of\ %----------\033[0m';bash \"%\""
endfunc

map <F9>c :call CompileRunCpp()<CR>
func! CompileRunCpp()
    exec "w"
    exec "!echo -e '\033[1;32mcompiling.....\033[0m';g++ -std=c++11 \"%\" -o \"%:r.exe\";echo -e '\033[1;34m-----------here_is_the_ans_of_%----------\033[0m';./\"%:r.exe\";echo -e '\033[1;33mend...\033[0m';rm \"%:r.exe\""
    "exec "!./%:r.exe"
endfunc

map <F9>j :call CompileRunJava()<CR>
func! CompileRunJava()
    exec "w"
    exec "!echo -e '\033[1;32mcompiling.....\033[0m';javac %;echo -e '\033[1;34m-----------here_is_the_ans_of_%----------\033[0m';java %:r;echo -e '\033[1;33mend...\033[0m';rm %:r.class"
endfunc

map <F9>g :call CompileRunGo()<CR>
func! CompileRunGo()
    exec "w"
    exec "!go run %"
endfunc

nnoremap <F11> :set spell!<CR>


" syntax highlight related
" The colors come from 
" https://stackoverflow.com/questions/16014361/how-to-set-a-custom-color-to-folded-highlighting-in-vimrc-for-use-with-putty 
" https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

augroup PythonOutlines
    au! 
    " this is for simple words highlight syntax
    " autocmd FileType python,sh syntax match Outlines1 /\(^# # Outlines:\)\@=.*/
    " autocmd FileType python,sh syntax match Outlines2 /\(^# ## Outlines:\)\@=.*/
    " autocmd FileType python,sh hi Outlines1 cterm=bold ctermbg=blue guibg=LightYellow
    " autocmd FileType python,sh hi Outlines2 cterm=bold ctermbg=darkblue guibg=LightYellow

    " Below is for line hightlight
    if $TERM =~ "256"
        autocmd FileType python,sh hi Outlines1 cterm=bold ctermbg=017 ctermfg=White
        autocmd FileType python,sh hi Outlines2 cterm=bold ctermbg=019 ctermfg=White
        autocmd FileType python,sh hi cellDelimiterHi ctermbg=233 ctermfg=DarkGray
    else
        autocmd FileType python,sh hi Outlines1 cterm=bold ctermbg=darkblue ctermfg=White
        autocmd FileType python,sh hi Outlines2 cterm=bold ctermbg=blue ctermfg=White
        autocmd FileType python,sh hi cellDelimiterHi ctermbg=Black ctermfg=DarkGray
    endif

    autocmd FileType python,sh sign define cellLine linehl=cellDelimiterHi
    autocmd FileType python,sh sign define O1 linehl=Outlines1
    autocmd FileType python,sh sign define O2 linehl=Outlines2

    function! HighlightCellDelimiter()
      execute "sign unplace * group=cellsDelimiter file=".expand("%")
      execute "sign unplace * group=otl1 file=".expand("%")
      execute "sign unplace * group=otl2 file=".expand("%")

      for l:lnum in range(line("w0"), line("w$"))
        if getline(l:lnum) =~ "^# %%"
          execute "sign place ".l:lnum." line=".l:lnum." name=cellLine group=cellsDelimiter file=".expand("%")
        elseif getline(l:lnum) =~ "^# # Outlines:"
          execute "sign place ".l:lnum." line=".l:lnum." name=O1 group=otl1 file=".expand("%")
        elseif getline(l:lnum) =~ "^# ## Outlines:"
          execute "sign place ".l:lnum." line=".l:lnum." name=O2 group=otl2 file=".expand("%")
        endif
      endfor
    endfunction

    autocmd! CursorMoved *.py,*.sh call HighlightCellDelimiter()
augroup END



" 快速替换
" TODO: 这个highlight 是个啥鬼.... 好像根本不需要是不是....
" - 可能我只是想写一个替换highlight的快捷键，结果弄错了
nnoremap <expr> <plug>HighlightReplaceW '/\<'.expand('<cword>').'\><CR>``:%s/\<'.expand('<cword>').'\>/'.expand('<cword>').'/g<left><left>'
" 这里蕴含了单引号字符串包含单引号的技巧(''代表', 后来发现不用了)
" - https://vi.stackexchange.com/a/9046
" - :h literal-string
vnoremap <expr> <plug>VHighlightReplaceW '/\<'.expand('<cword>').'\><CR>``:s/\<'.expand('<cword>').'\>/'.expand('<cword>').'/g<left><left>'
nmap <leader>rp <plug>HighlightReplaceW
vmap <leader>rp <plug>VHighlightReplaceW

" 这是不用分词符版本的
nnoremap <expr> <plug>HighlightReplace ':%s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'
vnoremap <expr> <plug>VHighlightReplace ':s/'.expand('<cword>').'/'.expand('<cword>').'/g<left><left>'
nmap <leader>rP <plug>HighlightReplace
vmap <leader>rP <plug>VHighlightReplace


" 个人喜欢的快速移动
" - 在insert mode下快速到行尾
inoremap <C-e> <C-o>$




"
" The plugins I always need -------------------------
" https://github.com/neovim/neovim/wiki/Related-projects#plugins
"

" Plug 'liuchengxu/vim-which-key'
" I should before any key define based on vim-which-key

set timeoutlen=500 " By default timeoutlen is 1000 ms
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
" vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>
let g:which_key_map =  {}
" 我理解这里的所有的map命令 CMD 最后都会变成 :CMD<CR>



"
" ctrlp.vim
" https://github.com/kien/ctrlp.vim
" let g:ctrlp_working_path_mode = 'wa'
" nnoremap <silent> <leader>cp  :<C-u>CtrlPClearCache<CR>
nmap <silent> <C-P>  :<C-u>CocList files<CR>
let g:ctrlp_map = ''
let g:ctrlp_cmd = ''




"
" vimwiki http://www.vim.org/scripts/script.php?script_id=2226
"
" map tb :VimwikiTable
" map t<space> <Plug>VimwikiToggleListItem
let g:vimwiki_hl_headers = 1
" let g:vimwiki_conceallevel = 0


"
" Nerdtree http://www.vim.org/scripts/script.php?script_id=1658
"
nnoremap <silent> <F7> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.orig$', '\.pyo$']


"
" Tagbar http://www.vim.org/scripts/script.php?script_id=3465
"
" nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>
let g:tagbar_sort = 0


"
" vim-flake8 , PyFlakes to find static programming errors and  PEP8 ...
"   git clone https://github.com/nvie/vim-flake8 ~/.vim/bundle/
"   sudo apt-get install python-flake8
let g:no_flake8_maps=1
" autocmd BufWritePost *.py call Flake8() " XXX 这个功能需要安装插件
autocmd FileType python map <buffer> <F12> :call Flake8()<CR>


"
" matchit http://www.vim.org/scripts/script.php?script_id=39
"



"
" vim-go
" https://github.com/fatih/vim-go
" 集成了绝大部分go的开发环境
" 依赖 GOPATH, GOROOT
" 查文档时不会在项目里查，因为不知道项目在哪里呀！
" 所以回去系统默认的函数库中(依赖GOROOT??) 和 GOPATH/src下查询，所以设置好gopath非常重要呀
"
" 有用的命令
" :GoImports 自动import缺失工具
" :GoCallers
" 这个可能有很多可能性，只会列出一种情况(TODO:想想原理是啥，以后别被这个坑才好)
" :GoImplements 找到interface的实现， 和 GoCallers 那几个命令都是依赖于
" oracle的， 但是还不知道怎么用 g:go_oracle_scope 这个参数, 用 下面这个成功过
" let g:go_oracle_scope = 'github.com/GoogleCloudPlatform/kubernetes/cmd/kubectl XXXX'
" 但是非常的慢
au FileType go nmap <Leader>gd <Plug>(go-doc)



"
" TComment
" https://github.com/tomtom/tcomment_vim
" gc 确定一切


"
" vim-slime  &  vim-ipython-cell
" https://github.com/jpalardy/vim-slime
" NOTICE: slime代表着一种边写脚本边搞bash的习惯！一种新的思维方式
" ":i.j" means the ith window, jth pane
" C-c, C-c  --- the same as slime
" C-c, v    --- mnemonic: "variables"
let g:slime_target = "tmux"
" 这个一定要和ipython一起用，否则可能出现换行出问题
let g:slime_python_ipython = 1


" always send text to the pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------
" Keyboard mappings. <Leader> is \ (backslash) by default

let g:which_key_map['p'] = {
    \ 'name' : 'IPython Cell',
    \'s' : [':SlimeSend1 ipython --matplotlib', 'start ipython with matplotlib'],
    \'r' : ['IPythonCellRun', 'IPythonCellRun'],
    \'R' : ['IPythonCellRunTime', 'IPythonCellRunTime'],
    \'e' : ['IPythonCellExecuteCellVerbose', 'Execute Cell'],
    \'E' : ['IPythonCellExecuteCellVerboseJump', 'Execute Cell Jump'],
    \'l' : ['IPythonCellClear', 'IPythonCellClear'],
    \'x' : ['IPythonCellClose', 'IPythonCellClose'],
    \'c' : [':SlimeSend', 'Send line or selected'],
    \'p' : ['IPythonCellPrevCommand', 'Previous Command'],
    \'Q' : ['IPythonCellRestart', 'restart ipython'],
    \'d' : [':SlimeSend1 %debug', 'debug mode'],
    \'t' : [':SlimeSend1 %load_ext autotime', 'debug mode'],
    \'q' : [':SlimeSend1 exit', 'exit'],
    \'k' : ['IPythonCellPrevCell', 'Prev Cell'],
    \'j' : ['IPythonCellNextCell', 'Next Cell']
    \ }

" TODO: Combine the ipython cel and jupyter-vim
" - https://vi.stackexchange.com/a/18946



"
" vim-airline
let g:airline#extensions#tabline#enabled = 1
" vim-airline-themes
let g:airline_theme='dark'


"
" heavenshell/vim-pydocstring
" Docstring的详细格式解析: https://stackoverflow.com/a/24385103
nmap <silent> <leader>d <Plug>(pydocstring)
let g:pydocstring_formatter='numpy'


"
" python-mode
" 这个插件遇到过保存失败,导致运行脚本跑的不是最新代码！！！！
" help PymodeDoc
" 现在暂时将pymode关闭，每次的弹窗还得管真是比较烦人, 应该都可以被coc.nvim代替
" TODO: 但是不知道coc.nvim会不会受到 pymode的参数的影响，所以下面先不删除
" let g:pymode_python = 'disable'
" " this plugin will auto folder all the code, please use `:help zo` to find the code
" let g:pymode_lint_ignore = ["E0100", "E501", "E402"]
" " E402 module level import not at top of file
" let g:pymode_doc=0  " This will conflict with coc
" let g:pymode_rope=0  " disable refracting because I don't use it
" let g:pymode_folding=0  " auto folding really makes python coding really slow.
" " lint还是挺有用的，改完代码马上就能检查出一些语法错误，不必等到运行时发现
" let g:pymode_lint_unmodified = 1  " Check code on every save (every)
" " Set this to make wrap works
" let g:pymode_options = 0





"
" vim-surround
" https://github.com/tpope/vim-surround
"




"
" bash-support
" https://www.tecmint.com/use-vim-as-bash-ide-using-bash-support-in-linux/
"

"
" mileszs/ack.vim
" let g:ackprg = 'ag --vimgrep'
" nnoremap <Leader>a :Ack




" BEGIN for coc ----------------------------------------------------------
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" disable python2 provider
let g:loaded_python_provider=0

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" # 这个地方可以和coc-snippet结合起来用,  直接将选中的code转化为 snippet
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>lc  :<C-u>CocList commands<cr>
" Show list comands
nnoremap <silent> <space>ll  :<C-u>CocList<cr>
" Show list vim comands
nnoremap <silent> <space>lv  :<C-u>CocList vimcommands<cr>

" ctags的默认参数是这个
" config/coc/extensions/node_modules/coc-python/resources/ctagOptions
" --extras参数出问题要么改参数成 extra，要么装能兼容版本的ctags deploy_apps/install_ctags.sh
" 如果太慢了，可以用 --verbose debug看看慢在哪里，可以在ctagOptions里面加上exclude
" 但是必须用恰好是文件夹名字，不然无法跳过,  --exclude=mlruns --exclude=models
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

" Do default action for next item.
nnoremap <silent> <space>lj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>lk  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>lp  :<C-u>CocListResume<CR>

nnoremap <silent> <Leader>gc :exe 'CocList -I --input='.expand('<cword>').' grep --ignore-case'<CR>
nnoremap <silent> <Leader>gr :exe 'CocList -I grep --ignore-case'<CR>


let g:which_key_map['l'] = {
    \ 'name' : 'coc-list',
    \'o' : [':CocList -I --auto-preview --ignore-case --input=outlines lines', 'Outlines'],
    \'i' : [':CocList -I --auto-preview --ignore-case lines', 'Search in this file'],
    \ }


" scroll the popup
" comes from https://github.com/neoclide/coc.nvim/issues/1405
" I think this is still experimental
function! s:coc_float_scroll(forward) abort
  let float = coc#util#get_float()
  if !float | return '' | endif
  let buf = nvim_win_get_buf(float)
  let buf_height = nvim_buf_line_count(buf)
  let win_height = nvim_win_get_height(float)
  if buf_height < win_height | return '' | endif
  let pos = nvim_win_get_cursor(float)
  if a:forward
    if pos[0] == 1
      let pos[0] += 3 * win_height / 4
    elseif pos[0] + win_height / 2 + 1 < buf_height
      let pos[0] += win_height / 2 + 1
    endif
    let pos[0] = pos[0] < buf_height ? pos[0] : buf_height
  else
    if pos[0] == buf_height
      let pos[0] -= 3 * win_height / 4
    elseif pos[0] - win_height / 2 + 1  > 1
      let pos[0] -= win_height / 2 + 1
    endif
    let pos[0] = pos[0] > 1 ? pos[0] : 1
  endif
  call nvim_win_set_cursor(float, pos)
  return ''
endfunction

nnoremap <silent><expr> <down> coc#util#has_float() ? coc#util#float_scroll(1) : "\<down>"
nnoremap <silent><expr> <up> coc#util#has_float() ? coc#util#float_scroll(0) : "\<up>"
inoremap <silent><expr> <down> coc#util#has_float() ? <SID>coc_float_scroll(1) : "\<down>"
inoremap <silent><expr> <up> coc#util#has_float() ? <SID>coc_float_scroll(0) : "\<up>"
vnoremap <silent><expr> <down> coc#util#has_float() ? <SID>coc_float_scroll(1) : "\<down>"
vnoremap <silent><expr> <up> coc#util#has_float() ? <SID>coc_float_scroll(0) : "\<up>"


let g:coc_global_extensions = [
 \ "coc-python",
 \ "coc-highlight",
 \ "coc-lists",
 \ "coc-json",
 \ "coc-explorer",
 \ "coc-snippets",
 \ ]
 " \ "coc-marketplace"

"  coc-marketplace",
" 个人经验 <space>c  setLinter ，把pylama 设置成错误提示的工具方便



" coc-explorer -------------------
let g:coc_explorer_global_presets = {
\   '.vim': {
\      'root-uri': '~/.vim',
\   },
\   'floating': {
\      'position': 'floating',
\   },
\   'floatingLeftside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'floatingRightside': {
\      'position': 'floating',
\      'floating-position': 'right-center',
\      'floating-width': 50,
\   },
\   'simplify': {
\     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }

" Use preset argument to open it
let g:which_key_map['e'] = {
    \ 'name' : 'coc-list',
    \'f' : [':CocCommand explorer --sources=buffer+,file+ --preset floatingRightside', 'Float Explorer'],
    \'c' : [':CocCommand explorer --sources=buffer+,file+', 'Side Explorer'],
    \'e' : [':CocCommand explorer --sources=buffer+,file+ --preset floating', 'Full Explorer'],
    \ }

" List all presets
" nmap <leader>el :CocList explPresets

" BUG
" 有tagbar(或许是别的窗口)的时候，coc-explorer  打开文件会有问题



" coc-snippet ------------------------
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)


" coc-list ------------------------------
" 这里感觉和文档写的不太一样
" - 默认 list.source.files.command 用 rg
" - 默认参数是 ["--color", "never", "--files"]
" - 所以要做修改需在这些默认值之后操作
"    - 比如想要follow the link就得这么操作: list.source.files.args": ["-L", "--color", "never", "--files"]
" https://github.com/neoclide/coc-lists/issues/69


" DEBUG相关
" 当出现下面情况都先确认环境有没有弄错
" - 解析pylama解析包失败时(找不到包, 比如import时提示无法解析)
" - 做代码跳转时，提示版本太老
" <space>c -> python.setInterpreter 
" 如果上述命令出错了，很可能是python插件没有加载:  <space>e 来加载插件
" 会频繁出现上面问题的原因是它会因为新项目不知道default interpreter是什么
" - https://github.com/neoclide/coc-python/issues/55
"
" Jedi error: Cannot call write after a stream was destroyed
" pip search jedi, 看看你安装的是不是最新版
"
" Coc does not install extension if file with same name exists
" 一直尝试安装一个不需要的插件，有可能之前安装后没卸干净 ~/.config/coc/extensions/package.json
" 实在不行,最后从一个好的电脑上找到了~/.config/coc/ ， 然后拷贝了过来

" 如果出现运行特别慢的情况，那么可能是因为数据和代码存在一起了,
" 数据小文件特别多，建议把数据单独放到外面。不然得一个一个插件单独地配置XXX_ignore

" 如果pylint import找不到module: 是因为pylint无法解析sys.path.append语句
" 可以在 `${workspaceFolder}/.env` 中直接设置`PYTHONPATH`
" - https://github.com/neoclide/coc-python
" - https://code.visualstudio.com/docs/python/environments#_use-of-the-pythonpath-variable

" 各种配置通过这里来设置 
" 直接编辑 ~/.config/nvim/coc-settings.json 或者  CocConfig

" 好用的地方:  grep, gr; 看上面的定义，IDE常用的地方上面都有


" END   for coc ----------------------------------------------------------



" BEGIN for vim-indent-guides ----------------------------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
" END   for vim-indent-guides ----------------------------------------------------------


" 'vim-ctrlspace/vim-ctrlspace'
set nocompatible
set hidden
set encoding=utf-8
hi link CtrlSpaceNormal   PMenu
hi link CtrlSpaceSelected PMenuSel
hi link CtrlSpaceSearch   Search
hi link CtrlSpaceStatus   StatusLine
" visual mode is not useful for me at all
nnoremap <silent>Q :CtrlSpace<CR>
" set showtabline=0
" 好用的: 
" - l可以快速列出所有的tab级别的内容
" 坑:
" - workspace进去默认是一个向上的箭头，表示load;
"   按下s后，会变成向下的箭头代表save，箭头非常不明显
" - 想disable 文件搜索，但是一直没有成功
"   - let g:CtrlSpaceIgnoredFiles = '*'
"   - let g:CtrlSpaceGlobCommand = 'echo "disabled"'



" BEGIN for mhinz/vim-startify ----------------------------------------------------------
let g:ascii_yang = [
      \'____  ________________________  _____________   __________',
      \'__  |/ /___  _/__    |_  __ \ \/ /__    |__  | / /_  ____/',
      \'__    / __  / __  /| |  / / /_  /__  /| |_   |/ /_  / __  ',
      \'_    | __/ /  _  ___ / /_/ /_  / _  ___ |  /|  / / /_/ /  ',
      \'/_/|_| /___/  /_/  |_\____/ /_/  /_/  |_/_/ |_/  \____/   ',
      \]

 let g:ascii_art = [
       \'                           O                                         ',
       \'                                 O           O O                     ',
       \'                                       O     |_|                     ',
       \'                                           <(+ +)>                   ',
       \'                                            ( u )                    ',
       \'                                               \\                    ',
       \'                                                \\                   ',
       \'                                                 \\               )  ',
       \'                                                  \\             /   ',
       \'                                                   \\___________/    ',
       \'                                                   /|          /|    ',
       \'                                                  //||      ( /|| =3 ',
       \'                                                 //-||------//ω||    ',
       \'                                                //  ||     //  ||    ',
       \'                                                \\  ||     \\  ||    ',
       \'                                                /_\ /_\    /_\ /_\   ',
       \]

 let g:startify_custom_header =
       \ 'startify#pad(g:ascii_yang + startify#fortune#boxed() + g:ascii_art)'
 let g:startify_change_to_dir = 0
" END   for mhinz/vim-startify ----------------------------------------------------------



" BEGIN for 'vim-vdebug/vdebug' ---------------------------------------------------
"
" TODO: 
" 调整mapping, 和 which-key 兼容
" 安装pydbgp:   pip install komodo-python3-dbgp
" 1) :VdebugStart
" 2) pydbgp  -d  localhost:9000 a.py
" END   for 'vim-vdebug/vdebug' ---------------------------------------------------



" jupyter-vim
let g:which_key_map['j'] = {
    \ 'name' : 'jupyter-vim',
    \'e' : ['JupyterSendCell', 'Jupyter Send Cell'],
    \'d' : ['JupyterDisconnect', 'Jupyter Disconnect'],
    \ }
let g:jupyter_mapkeys=0
nmap <leader>jc  :<C-u>JupyterSendCount<CR>
vmap <leader>jc  :<C-u>'<,'>JupyterSendRange<CR>
" 注意只有disconnect之后才能再次connect
nmap <leader>js  :<C-u>JupyterConnect 
nmap <leader>jr  :<C-u>JupyterSendCode 
nmap <leader>jn  <esc>}o<CR># %%<esc>o
nmap <leader>jw  :<C-u>JupyterSendCode expand("<cword>")<CR>
nmap <leader>jl  :<C-u>JupyterSendCode "clear"<CR>
nmap <leader>jp  :<C-u>JupyterSendCode @"<CR>

nmap <Plug>RunCellAndJump <leader>je/# %%<CR>:noh<CR>
\:silent! call repeat#set("\<Plug>RunCellAndJump", v:count)<CR>
nmap <leader>jE <Plug>RunCellAndJump
" 依赖vim-repeat 才能
" config come from http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/





" BEGIN 'unblevable/quick-scope' ----------------------------------------------------------
" let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_buftype_blacklist = ['nofile', 'terminal']  " in case it change the color of some pop text

" END   'unblevable/quick-scope'----------------------------------------------------------



" BEGIN 'jiangmiao/auto-pairs'----------------------------------------------------------
" alt + p 可以控制 pair 的开关
" alt + e 可以在将行中间补全的括号自动放到末尾
" END   'jiangmiao/auto-pairs'----------------------------------------------------------


" BEGIN 'airblade/vim-gitgutter' ------------------------------------------------------
let g:which_key_map['h'] = {
    \ 'name' : 'GitGutter(Hank)',
    \'[' : ['<Plug>(GitGutterPrevHunk)', 'PrevHunk'],
    \']' : ['<Plug>(GitGutterNextHunk)', 'NextHunk']
    \ }
" END   'airblade/vim-gitgutter' ------------------------------------------------------


" Nvim usage cheetsheet


" 目录
" - 设计理念
" - 查看当前设置
" - Moving
" - 其他
" - 坑
" - script
" - TODO


" ========== 设计理念 ==========
" buffer, window, tab的设计理念
" A buffer is the in-memory text of a file
" A window is a viewport on a buffer.
" A tab page is a collection of windows.
" 所以之前每次开tab而不是buffer，感觉tagbar和nerdtree总是要重复打开很烦;

" map的设计逻辑; 各种map的区别
" - 有没有re代表会不会map后再次被map
" - 前缀代表它在什么模式下生效
" - 它可以映射成一段直接输入，也能映射成一个将会被解析成字符串的表达式
"   - :help <expr>  " 如果想让map映射到一个可解释的字符串


" ========== 查看当前设置 ==========
" global settings
" 检查按键到底被映射成什么了
" :verbose nmap <CR>


" ========== Moving ==========
" Moving: http://vimdoc.sourceforge.net/htmldoc/motion.html
" help diw daw 等等


" ========== 其他 ==========
" 匹配: 正向预查，反向预查，环视


" ========== 坑 ==========
" terminal mode 可以解决终端乱码的问题， 还可以用  <c-\><c-n> 和 i 在normal
" model 和terminal model之间切换
"
" CocInstall 会产生空的文件
" https://github.com/neoclide/coc.nvim/issues/2010
"
" ctrlspace load workspace非常慢
" https://github.com/vim-ctrlspace/vim-ctrlspace/issues/6


" ========== script ==========
" vim script cheatsheet https://devhints.io/vimscript
" help script


" ========== TODO ==========
" Highlight 整行
" - https://vi.stackexchange.com/questions/15505/highlight-whole-todo-comment-line
" - https://stackoverflow.com/questions/2150220/how-do-i-make-vim-syntax-highlight-a-whole-line


" other cheetsheet
" deploy_apps/install_neovim.sh
