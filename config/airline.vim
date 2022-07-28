 let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter =  'unique_tail_improved'
let g:airline_theme='badwolf'
let g:airline#extensions#battery#enabled = 1
let g:airline#extensions#battery#format = '%p%%'
let g:airline#extensions#battery#full_symbol = '✓'
let g:airline#extensions#battery#empty_symbol = '✗'
let g:airline#extensions#battery#low_symbol = '⚡'
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 79,
      \ 'x': 46,
      \ 'y': 88,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ }
" let g:airline#extensions#lsp#progress_skip_time = 10 ""(default)
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
  nmap <leader>0 <Plug>AirlineSelectTab0
  nmap <leader>- <Plug>AirlineSelectPrevTab
  nmap <leader>+ <Plug>AirlineSelectNextTab


    
