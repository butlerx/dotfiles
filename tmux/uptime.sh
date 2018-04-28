#!/usr/bin/env sh
uptime | awk -F '( |,|:)+' '{print $6,$7,$8":"$9}'
