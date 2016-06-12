#!/bin/bash
while true
do
  markup=
  workspaces_status=$(i3-msg -t get_workspaces)
  output=$1
  for w in $(jq '.[] | .num' <<< "$workspaces_status"); do
      ws_output=$(jq -r '.[] | select(.num == '$w') | .output' <<< "$workspaces_status")
      [[ -n $output && $output != $ws_output ]] && continue

      visible=$(jq '.[] | select(.num == '$w') | .visible' <<< "$workspaces_status")
      focused=$(jq '.[] | select(.num == '$w') | .focused' <<< "$workspaces_status")
      urgent=$(jq '.[] | select(.num == '$w') | .urgent' <<< "$workspaces_status")

      unset mk_active mk_visible mk_urgent
      [[ $visible == true ]] && mk_visible='bgcolor="#5ba7c3"'
      [[ $focused == true ]] && mk_active='underline="single" underline_color="#cccccc"'
      [[ $urgent == true ]] && mk_urgent='bgcolor="#cc0000" underline="single" underline_color="#cccccc"'
      markup+="<span $mk_visible $mk_active $mk_urgent> $w </span> "
  done

  echo $markup
done
