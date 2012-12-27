#!/bin/bash

if [[ -f .localconf ]]; then
	source .localconf
else
	ARCH="arm"
	HOST="arndale"
	GUEST1="guest1"
	WEBHOST="192.168.27.90"
	REPTS="10"

	echo -n "What's the architecture? [$ARCH]:"
	read _ARCH
	if [[ -n "$_ARCH" ]]; then
		ARCH="$_ARCH"
	fi

	echo -n "What's the DNS/IP of the host? [$HOST]:"
	read _HOST
	if [[ -n "$_HOST" ]]; then
		echo $_HOST
		HOST="$_HOST"
	else
		echo $_HOST
	fi

	echo -n "What's the DNS/IP of the guest? [$GUEST1]:"
	read _GUEST1
	if [[ -n "$_GUEST1" ]]; then
		GUEST="$_GUEST1"
	fi

	echo -n "What's the DNS/IP of the web server? [$WEBHOST]:"
	read _WEBHOST
	if [[ -n "$_WEBHOST" ]]; then
		GUEST="$_WEBHOST"
	fi

	echo -n "How many repititions of each test do you want? [$REPTS]:"
	read _REPTS
	if [[ -n "$_REPTS" ]]; then
		REPTS="$_REPTS"
	fi

	echo "ARCH=\"$ARCH\"" > .localconf
	echo "HOST=\"$HOST\"" >> .localconf
	echo "GUEST1=\"$GUEST1\"" >> .localconf
	echo "WEBHOST=\"$WEBHOST\"" >> .localconf
	echo "REPTS=\"$REPTS\"" >> .localconf
fi

echo ""

# Commands
if [[ "$ARCH" == "x86" ]]; then
	START_VM_COMMAND="virsh start guest1"
	SHUTDOWN_VM_COMMAND="virsh -q destroy guest1"
	TOOLS=tools_x86
	VM_CONSOLE=""
else
	ARCH="arm"
	VM_CONSOLE=/tmp/ubuntu.console
	START_VM_COMMAND="cd /root && ./run-ubuntu.sh --console $VM_CONSOLE -m 1536"
	SHUTDOWN_VM_COMMAND="pkill -9 qemu-system-arm"
	TOOLS=tools
fi
# Environment
IFS=$(echo -en "\n\t ")
LOGFILE=/tmp/kvmperf.log
OUTFILE=kvmperf.values
_OFN=1

while [[ -e $OUTFILE ]]; do
	OUTFILE=kvmperf.values.$_OFN
	_OFN=$(( $_OFN + 1 ))
done

# Silent SCP command
SSCP="scp -q"
SCP="$SSCP"

# Silent SSH command
SSH="ssh"
SSSH="ssh -q 1>/dev/null 2>/dev/null"
