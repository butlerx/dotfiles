#!/bin/bash
  markup=
  workspaces_status=$(i3-msg -t get_workspaces)
  output=$1
  for w in $(jq '.[] | .num' <<< "$workspaces_status"); do
      ws_output=$(jq -r '.[] | select(.num == '$w') | .output' <<< "$workspaces_status")
      [[ -n $output && $output != $ws_output ]] && continue

      visible=$(jq '.[] | select(.num == '$w') | .visible' <<< "$workspaces_status")
      focused=$(jq '.[] | select(.num == '$w') | .focused' <<< "$workspaces_status")
      urgent=$(jq '.[] | select(.num == '$w') | .urgent' <<< "$workspaces_status")

      unset bgcolor underline
      [[ $visible == true ]] && bgcolor='bgcolor="#5ba7c3"'
      [[ $focused == true ]] && underline='underline="single" underline_color="#cccccc"'
      [[ $urgent == true ]] && bgcolor='bgcolor="#cc0000"' && underline='underline="single" underline_color="#cccccc"'
      markup+="<span $bgcolor $underline> $w </span> "
  done

  echo $markup
