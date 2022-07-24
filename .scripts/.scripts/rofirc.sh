SCRIPTS_DIR="~/.scripts/"
ALIAS_DEF="aliases.sh"
FUNCTION_DEF="functions.sh"
bash -c ". ${SCRIPTS_DIR}${ALIAS_DEF}; . ${SCRIPTS_DIR}${FUNCTION_DEF}; alias | awk -F'[ =]' '{print \$2}'; declare -F | sed 's/declare -f //g'"


