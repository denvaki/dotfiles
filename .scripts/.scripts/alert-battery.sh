#!/bin/bash
bat_files="/sys/class/power_supply/BAT0"
critical_level=5
rescue_suspend_countdown=20

function bat_status() {
       	cat ${bat_files}/status
}

function capacity() {
	cat "${bat_files}/capacity"
}

function rescue_suspending() {
	sleep ${rescue_suspending_countdown} 
	if [[ $(capacity) -le ${critical_level} && "$(bat_status)" == "Discharging" ]]; then
		systemctl suspend
	fi
}

if [[ "$(bat_status)" == "Discharging" && "$(capacity)" -le 20  ]]; then
	if [[ "$(capacity)" -le ${critical_level}  ]]; then
		urgency_level='critical'
		body="Battery level is too critical. Laptop will be suspended in ${rescue_suspending_countdown} seconds"
		rescue_suspending &
	elif [[ "$(capacity)" -le 8 ]]; then
		urgency_level='critical'
		body="Only $(capacity)% battery remaining"
	else 
		urgency_level='normal'
		body="Only $(capacity)% battery remaining"
	fi
	echo "Battery alert - $(capacity)% and status $(bat_status)"
    notify-send \
        --icon=/usr/local/share/icons/battery_low_dark.png \
	-u "${urgency_level}" \
        "Low battery" \
	"${body}"
fi
