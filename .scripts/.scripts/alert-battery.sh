#!/bin/bash
bat_files="/sys/class/power_supply/BAT0"
critical_level=8
rescue_suspend_countdown=20

function bat_status() {
       	cat ${bat_files}/status
}

function capacity() {
	cat "${bat_files}/capacity"
}

function rescue_suspending() {
	sleep ${rescue_suspend_countdown} 
	echo blah
	if [[ $(capacity) -le ${critical_level} && "$(bat_status)" == "Discharging" ]]; then
		systemctl suspend
	fi
}

function send_notification() {
	notify-send \
        	--icon=/usr/local/share/icons/battery_low_dark.png \
		-u "$1" \
        	"Low battery" \
		"$2"

}

if [[ "$(bat_status)" == "Discharging" && "$(capacity)" -le 20  ]]; then
	if [[ "$(capacity)" -le ${critical_level}  ]]; then
		urgency_level='critical'
		body="Battery level is too critical. Laptop will be suspended in ${rescue_suspend_countdown} seconds"
		send_notification "${urgency_level}" "${body}"
		rescue_suspending
	elif [[ "$(capacity)" -le 8 ]]; then
		urgency_level='critical'
		body="Only $(capacity)% battery remaining"
		send_notification "${urgency_level}" "${body}"
	else 
		urgency_level='normal'
		body="Only $(capacity)% battery remaining"
		send_notification "${urgency_level}" "${body}"
	fi
	echo "Battery alert - $(capacity)% and status $(bat_status)"
fi
