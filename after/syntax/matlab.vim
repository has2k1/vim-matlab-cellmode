" Bold Cell title Bold font in the cell title
syntax match MATCELL /%%$/
syntax match MATTITLEDCELL /%%.\+$/

highlight MATTITLEDCELL cterm=bold term=bold gui=bold guibg='#827B60' guifg='#DDDDDD'
highlight MATCELL cterm=bold term=bold gui=bold guibg='#827B60' guifg='#000000'
