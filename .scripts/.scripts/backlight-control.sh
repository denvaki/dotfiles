#!/bin/bash
# $1 should be numberic value of percentage, $2 operator by default "+"
[[ -z "${1}" ]] && exit 1
[[ -z "${2}" ]] && 2="+"
CARD=nvidia_0
BL_MAIN_PATH="/sys/class/backlight/*"
MAX_BL_PATH="${BL_MAIN_PATH}/max_brightness"
CUR_BL_PATH="${BL_MAIN_PATH}/brightness"

current_bl=$(cat ${CUR_BL_PATH})
max_bl=$(cat ${MAX_BL_PATH})

#inew_bl=$(( ${current_bl} ${1} ))
new_bl=$(( ${current_bl} ${2} ${max_bl} * ${1} / 100 ))

[[ ${new_bl} -gt ${max_bl} ]] && new_bl=${max_bl}
[[ ${new_bl} -lt 0 ]] && new_bl=0

echo ${new_bl} > ${CUR_BL_PATH}
