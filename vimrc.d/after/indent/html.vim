" Don't re-indent lines on right-angle-bracket or enter
setlocal indentkeys-=<>>
setlocal indentkeys-=<Return>
let b:undo_ftplugin .= '|setlocal indentkeys<'
