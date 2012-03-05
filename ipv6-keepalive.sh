#!/bin/sh

WIRELESS=iwlagn
PING=ping6
HOST=ipv6.google.com

while true; do 
        if $PING -c 5 $HOST; then
                sleep 5
        else
		echo "IPv6 down, restarting: " `date`
		# If down the interface so we can remove the module
                ifdown wlan0
		# Reload the module
                modprobe -r $WIRELESS
                modprobe $WIRELESS
		# Wait for the module to get it's act together
                sleep 5
		# Restart the network
                /etc/init.d/wpa-ifupdown restart
                /etc/init.d/networking restart
                /etc/init.d/network-manager restart
		# Wait for the network to restart properly
		sleep 60
		# Restart the IPv6 tunnel
		#killall -9 gw6c
		/etc/init.d/aiccu stop
		sleep 5
		/etc/init.d/aiccu start
		sleep 5
        fi
done

