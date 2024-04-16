#!/bin/bash

#DateToday
date=`date +"%Y-%m-%d %T"`

echo "*********** Starting Today - " $date " - Check Of IP ***********"

#IP ADDRESS TODAY
ethernetIp=`hostname -I | awk '{ print $1}'`
wlanIp=`hostname -I | awk '{ print $2}'`

#Reference file that stores current and previus WAN IP Address
filename="my-ip.txt"

#Check if the Reference File exists else create one
if [ -f $filename ]
then
	#Logic to read the last line of the above and store data in variables with space delimiter
	IFS=' ' read -r dateNow timeNow ipFromThirtyMinutesBefore ethoIP wlanIp comments < <(tail -n1 $filename)
else
	touch my-wan-ip.txt

#Logic to read the last line of the above and store data in variables with space delimiter
	IFS=' ' read -r dateNow timeNow ipFromThirtyMinutesBefore ethoIP wlanIp comments < <(tail -n1 $filename)
fi

echo IP Address dateNow - $dateNow from file - $filename was $ipFromThirtyMinutesBefore

echo Ethernet and WLAN IP Address Now - $date is $ethernetIp $wlanIp

#Logic to check if the current IP is the same from the Previous Day
if [ "$ethernetIp" == "$ipFromThirtyMinutesBefore" ]
        then
                echo INFO - IP HAS NOT CHANGED
		echo ${date} ${ethernetIp} ${wlanIp} IP HAS NOT CHANGED >> $filename
		echo "*********** END OF TODAY - " $date " RUN ********************** "
        else
                echo WARNING - IP HAS CHANGED
				echo ${date} ${ethernetIp} ${wlanIp} IP HAS CHANGED >> $filename
		echo "*********** END OF TODAY - " $date " RUN ********************** "
fi
