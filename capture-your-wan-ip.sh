#!/bin/bash

#DateToday
date=`date +"%Y-%m-%d %T"` 

#IP ADDRESS TODAY
ip=`curl icanhazip.com`

#Reference file that stores current and previus WAN IP Address
filename="./my-wan-ip.txt"

#Check if the Reference File exists else create one  
if [-f $filename]
	then
#Logic to read the last line of the above and store data in variables with space delimiter
IFS=' ' read -r yesterdayDate yestedayDateTime ipFromYesterday comments < <(tail -n1 $filename)
	else 
touch my-wan-ip.txt

#Logic to read the last line of the above and store data in variables with space delimiter
IFS=' ' read -r yesterdayDate yestedayDateTime ipFromYesterday comments < <(tail -n1 $filename)
fi

echo IP Address From Last Day - $yesterdayDate is $ipFromYesterday

#Logic to check if the current IP is the same from the Previous Day
if [ "$ip" == "$ipFromYesterday" ]
        then
                echo TRUE - IP HAS NOT CHANGED
		echo ${date} ${ip} IP HAS NOT CHANGED >> my-wan-ip.txt
        else 
                echo FALSE - IP HAS CHANGED
		echo "Hello From Raspberry PI" | mail -s "WAN IP Has CHANGED" gmalawarayan@gmail.com
                echo ${date} ${ip} IP HAS CHANGED >> my-wan-ip.txt
fi
