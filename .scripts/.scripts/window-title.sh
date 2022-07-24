#!/bin/sh

xprop -root _NET_ACTIVE_WINDOW | while read -r wid; do
    wid=$(echo $wid | cut -d ' ' -f 5)
    if [ "$wid" != "0x0" ] && [ "$wid" != "0xffffffff" ]; then
	echo "$wid" >> /tmp/wid
        cls=$(xprop -id $wid WM_CLASS)
        cls=$(echo $cls | cut -d ' ' -f 4)
        cls=$(echo $cls | sed -e 's/^.//;s/.$//;s/^\(.\)/\u\1/')
	name=$(xprop -id $wid WM_NAME | awk '{ p=index($0," = "); print substr( substr($0,p+3), 2, length(substr($0,p+3)) -2 ) }')

        #echo "$cls:$name"
	if [ "${cls}" = "${name}" ]; then 
		title="${cls}"
	else
		title="${cls}:${name}"
	fi
	
	len="$( echo ${title} | awk '{ print length($0) }' )" 	
	echo "len is ${len}, cls=${cls}, name=${name}  " >> /tmp/blah
	if [ ${len} -gt 40 ]; then
		echo ${title} | awk '{ print substr($0, 0, 37) "..." }'
	else
		echo ${title} | awk '{ print substr($0, 0, 40) }'
	fi


    else
        echo ""
    fi
done
