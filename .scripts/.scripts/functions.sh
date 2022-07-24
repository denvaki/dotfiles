vpn () {
    [[ "${1}" == "0" ]] && pgrep openconnect && pkexec kill $(pgrep openconnect)
    [[ "${1}" == "1" || "${1}" == "" ]] && openconnect-sso -s "gw1.tln.pipedrive.net"  -l DEBUG -- -b 2>&1 >> /tmp/openconnect.log
    [[ "${1}" == "2" ]] && (vpn 0; vpn 1)
}

show_deprecated () {
	[ ! -f "package-lock.json" ] && echo -e "${RED}No package-lock.json in PWD${NC}" && return 1;
	a=( $(jq -r '.packages | to_entries[] | select(.value.deprecated != null) | "\(.key)@\(.value.version)"' package-lock.json | rev | cut -d/ -f1 | rev) )
	npm ls ${a[@]}
}

show_unused () {
	[ ! -f "package.json" ] && echo -e "${RED}No package.json in PWD${NC}" && return 1;
	echo -e "${RED}${BOLD}This shows only POTENTIAL unsed dependencies${NC}${NORM}"
	IFS=$'\n' all_deps=( $(jq -r '.dependencies | to_entries[] | "\(.key)"' package.json ) $(jq -r '.devDependencies | to_entries[] | "\(.key)"' package.json ) )
	for i in ${all_deps[@]}; do
		grep -q -r $i ./lib ./db ./test ./config ./server ./src ./bin 2> /dev/null
		[ $? != 0 ] && echo $i
	done
}


commit () {
	git commit $2 -m "$(git branch --show-current ): $1"
}
