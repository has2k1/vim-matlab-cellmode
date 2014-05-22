" Matlab Cell Mode
"
" Author: Hassan Kibirige <has2k1+github@gmail.com>
" Credit: http://bit.ly/ZhZEYr
" Last Modified: Wednesday 21 May 2014 05:54:52 PM CDT
" License: MIT License


" Do not load twice and allow user to prevent script from loading
if exists("g:loaded_matlab_cellmode")
   finish
endif
let g:loaded_matlab_cellmode = 1

" Save current compatibility options
let s:save_cpo = &cpo
set cpo&vim


" Functions
" ---------

" return 1 if set, 0 if not set
function! s:init_variable(var, value)
  if !exists(a:var)
    let {a:var} = a:value
    return 1
  endif
  return 0
endfunction

" Run the whole script matlab: Emulates "Run/F5" behavior
" (goes to the right directory and execute the whole script):
function! s:send_file()
   " save cursor position
   let l:cursor = getpos(".")
   let @+="cd('".expand("%:p:h")."\'); run('./".expand("%:f"). "')"
   call system('xclip -selection c ', @+)
   call system('xclip ', @+)
   " go back to cursor location
   call setpos('.', l:cursor)
   call s:paste_to_matlab()
endfunction

" Run the cell only : Emulates Ctrl+Enter behavior.
" Run from %% above OR start of file to %% below OR end of file
function! s:send_cell()
   let l:cursor = getpos(".")
   " pipe the cell to xclip
   " :silent ?%%.\+\|\%^?;/%%.\+\|\%$/w !xclip -selection c
   :silent ?%%\|\%^?;/%%\|\%$/w !xclip -selection c
   call setpos('.', l:cursor)
   call s:paste_to_matlab()
endfunction

" Run current line : Copy current line to clipboard and go to matlab window.
" (once again Control+V to paste it in matlab, if it's the short-cut you use
" in matlab)
function! s:send_line()
   " write current line and pipe to xclip
   :silent .w !xclip -selection c
   call s:paste_to_matlab()
endfunction

" Run selection : Emulates F9 behavior.
function! s:send_selected() range
   let l:cursor = getpos(".")
   " pipe the cell to xclip
   :silent execute a:firstline.",".a:lastline." w !xclip -selection c"
   call setpos('.', l:cursor)
   call s:paste_to_matlab()
endfunction

function! s:paste_to_matlab()
   " Save the vim editor id
   let l:vim_window_id = system("xdotool getactivewindow")
   " Focus on MATLAB window
   silent execute '!xdotool search --name "' . g:matlabcellmode_window_title .
            \ '" windowactivate --sync'
   " In MATLAB window, focus on the command window, then paste
   silent execute '!xdotool key ctrl+0 ctrl+v'
   " Return focus to vim editor
   silent execute '!xdotool windowactivate ' . l:vim_window_id
endfunction


" Options
" -------
call s:init_variable('g:matlabcellmode_window_title', 'MATLAB  R20')


" Public Interface
" ----------------
command! -n=0 MatlabCellmodeSendFile call s:send_file()
command! -n=0 MatlabCellmodeSendCell call s:send_cell()
command! -n=0 MatlabCellmodeSendLine call s:send_line()
command! -n=0 MatlabCellmodeSendSelected call s:send_selected()


" Clean up
" --------

" Restore previous external compatibility options
let &cpo = s:save_cpo
