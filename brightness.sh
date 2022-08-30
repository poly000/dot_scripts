#!/bin/bash

# first argument should be your device
DEVICE=$1

export DEVICE="/sys/class/backlight/$DEVICE"

typeset -i brightness=$(cat "$DEVICE/brightness")
typeset -i max_brightness=$(cat "$DEVICE/max_brightness")
typeset -i min_brightness=1
typeset -i step=1

# optional third argument specify a step
if [[ o"$3" != o ]]
then step=$3
fi

case $2 in
	inc)
		brightness=$((brightness + step))

		if [[ $brightness -ge $max_brightness ]]
		then brightness=$max_brightness
		fi
		;;

	dec)
		brightness=$((brightness - step))

		if [[ $brightness -lt $min_brightness ]]
		then brightness=$min_brightness
		fi
		;;

	*)
		echo "Usage:"
		echo "$0 {device} {inc|dec} [step](default: 1)"
		echo
		exit 4
		;;
esac

if ! echo $brightness >  "$DEVICE/brightness"
then 
	echo "cannot set brightness to $DEVICE!"
	echo "did you add yourself to 'video' group?"
fi
