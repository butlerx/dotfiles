#!/bin/bash
mute=`pacmd list-sinks | grep '^[[:space:]]muted:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed 's/.*\: //'`
vol=`pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' | awk '{print $NF}'`
if [ $mute == "no" ]
then
    if [ $vol -eq 100 ]
    then
        echo "  $vol"
    elif [ $vol -ge 50 ]
    then
        echo "   $vol"
    elif [ $vol -lt 50 ]
    then
        if [ $vol -lt 10 ]
        then
            echo "       $vol"
        else
            echo "    $vol"
        fi
    else
        :
    fi
else
    echo "  Mute "
fi
