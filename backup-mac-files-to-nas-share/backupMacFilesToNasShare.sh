#!/bin/bash

#DateToday
date=`date +"%Y-%m-%d %T"`

echo "*********** Starting Backup Task today - " $date " - Rsync Of Folders Begin ***********"

#Reference file that stores current and previus WAN IP Address
filename="~/log/backup.log"

#Check if the Reference File exists else create one
if [ -f $filename ]
then
    echo "it exists"
else
	touch ~/log/backup.log
fi

rsync -avp ~/Downloads/folder-to-bakup/ /Volumes/nas-folder-name/folder-within-nas-/where-you-want-to-backup >> ~/log/backup.log
rsync -avp ~/Pictures/folder-to-bakup/ /Volumes/nas-folder-name/folder-within-nas-/where-you-want-to-backup >> ~/log/backup.log
rsync -avp ~/Documents/folder-to-bakup/ /Volumes/nas-folder-name/folder-within-nas-/where-you-want-to-backup >> ~/log/backup.log

echo "*********** Ending Backup Task - " $date " - Rsync Of Folders Complete ***********"