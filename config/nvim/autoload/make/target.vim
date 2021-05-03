" Function to make the target for the recipe under the cursor
function! make#target#Make() abort

  " Declare list of targets to build
  let l:targets = []

  " Iterate back through the file starting at the current line looking for the
  " line with the target
  for l:li in reverse(range(1, line('.')))
    let l:line = getline(l:li)

    " If it matches the target format, we've found our line; split the targets
    " by space, and break
    let l:matchlist = matchlist(l:line, '^\([^:= \t][^:=]*\):')
    if len(l:matchlist)
      let l:targets = split(l:matchlist[1], '\s\+')
      break

    " If it wasn't the target line and doesn't have leading tabs, we're not in
    " a recipe block; break with an unset target
    elseif strpart(l:line, 0, 1) !=# "\t"
      break
    endif

  endfor

  " If we found targets, :make them; escape them if we can
  for l:target in l:targets
    if exists('*shellescape')
      let l:target = shellescape(l:target)
    endif
    execute 'make! -C %:p:h '.l:target
  endfor

endfunction
