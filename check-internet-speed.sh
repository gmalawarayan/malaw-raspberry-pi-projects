#!/bin/bash

#DateToday
date=`date +"%Y-%m-%d %T"`

echo "*********** Starting Today - " $date " - Check Of WAN IP ***********"

#Speed Test now
'$(speedtest)' >> speedtest.txt