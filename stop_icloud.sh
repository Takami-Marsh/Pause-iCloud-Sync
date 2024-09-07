#! /bin/sh

## Description -----------

# Anti cloudd and nsurlsessiond for macOS
# Looking for new 'cloudd' and 'nsurlsessiond' processes and killing them by getting their PIDs

# Made by Lucas Tarasconi
# Modified by Takami Marsh

## Spinner function -----------

# Source of the function : http://fitnr.com/showing-a-bash-spinner.html

spinner()
{
	local pid=$!
	local delay=0.4
	local spinstr='|/-\'
	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		local temp=${spinstr#?}
		printf " [%c]  " "$spinstr"
		local spinstr=$temp${spinstr%"$temp"}
		sleep $delay
		printf "\b\b\b\b\b\b"
	done
	printf "    \b\b\b\b"
}

## Color ---------

RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

PROCESS="${BLUE}[PROCESS]${NC}"
INFO="${GREEN}[INFO]${NC}"
WARNING="${ORANGE}[WARNING]${NC}"

## Welcome panel -----------


echo "+----------------------------------------+"
echo "| Starting annihilation of cloudd and    |"
echo "| nsurlsessiond                          |"
echo "|        Made by Lucas Tarasconi         |"
echo "|     Modified by Takami Marsh           |"
echo "+----------------------------------------+"


## Testing verbose mode -----------

verbose=0
if [ $# -eq 1 ]; then
	if [ $1 == "-v" ]; then
		verbose=1
	fi
fi


## Removing the temporary file when exiting -----------

quitting () {
	echo "\n"
	echo "${INFO} Removing temporary files"
	rm ./.cloudd ./.nsurlsessiond
	echo "+----------------------------------------+"
	echo "| Stopping annihilation of cloudd and    |"
	echo "| nsurlsessiond                          |"
	echo "+----------------------------------------+"
	exit 0
}

## Core of the script : kill all cloudd and nsurlsessiond processes and show them -----------

killIt () {
	n=$(expr $line)
	sudo kill $n
}


speaking (){
	printf "\n"
	killIt
	current_time="`date +%H:%M:%S`"
	printf "${PROCESS} ${current_time}"
	printf " - killing process number:  $n"
}

killProcesses () {
	process_name=$1
	temp_file="./.$process_name"
	pgrep -x $process_name > $temp_file
	while read line ; do
		if [ $verbose -eq 1 ] ; then
			speaking
		else 
			killIt
		fi
	done < $temp_file
	if [ $verbose -eq 1 ] ; then
		printf "\n"
		printf "${INFO} Probing for new $process_name processes"
	fi
}

## To avoid using too much CPU just to kill processes -----------

function waiting {
	sleep 1
}

## While function -----------

trap "quitting" SIGTERM SIGINT
printf "${WARNING} Password could be asked once to have the right to kill 'cloudd' and 'nsurlsessiond' \n"
if [ $verbose -eq 1 ] ; then
	printf "${INFO} Probing for new cloudd and nsurlsessiond processes  "
else
	printf "${INFO} Script is in progress ( '-v' for verbose mode): "
fi
sleep 1
while [[ 1 ]]; do
	pgrep -x cloudd > /dev/null
	if [ $? -eq 0 ]; then
		killProcesses cloudd
	fi
	
	pgrep -x nsurlsessiond > /dev/null
	if [ $? -eq 0 ]; then
		killProcesses nsurlsessiond
	else
		waiting & spinner
	fi
done
