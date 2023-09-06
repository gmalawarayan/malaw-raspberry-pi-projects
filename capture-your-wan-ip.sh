#!/bin/bash

#DateToday
date=`date +"%Y-%m-%d %T"`

echo "*********** Starting Today - " $date " - Check Of WAN IP ***********"

#IP ADDRESS TODAY
ip=`curl icanhazip.com`

#Reference file that stores current and previus WAN IP Address
filename="./my-wan-ip.txt"

#Check if the Reference File exists else create one
if [ -f $filename ]
then
	#Logic to read the last line of the above and store data in variables with space delimiter
	IFS=' ' read -r yesterdayDate yestedayDateTime ipFromYesterday comments < <(tail -n1 $filename)
else
	touch my-wan-ip.txt

#Logic to read the last line of the above and store data in variables with space delimiter
	IFS=' ' read -r yesterdayDate yestedayDateTime ipFromYesterday comments < <(tail -n1 $filename)
fi

echo IP Address From MY-WAN-IP.TXT is - $yesterdayDate was $ipFromYesterday

echo IP Address Today - $date is $ip

#Logic to check if the current IP is the same from the Previous Day
if [ "$ip" == "$ipFromYesterday" ]
        then
                echo INFO - IP HAS NOT CHANGED
		echo ${date} ${ip} IP HAS NOT CHANGED >> my-wan-ip.txt
		echo "*********** END OF TODAY - " $date " RUN ********************** "
        else
                echo WARNING - IP HAS CHANGED
				echo -e "Hello, \nYour WAN IP Address has changed \nFrom: " ${ipFromYesterday} "\nTo: " ${ip} "\n \n Thanks, \n Raspberry Pi WAM IP Checker" | mail -s "WAN IP Has CHANGED" gmalawarayan@gmail.com
				echo ${date} ${ip} IP HAS CHANGED >> my-wan-ip.txt
		echo "*********** END OF TODAY - " $date " RUN ********************** "
fi