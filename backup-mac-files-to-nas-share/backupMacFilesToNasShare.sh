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

rsync -avp ~/Downloads/Personal /Volumes/share-for-the-Home/backup/backup-oc-2023/backup/personal_rsync >> ~/log/backup.log
rsync -avp ~/Pictures/photos /Volumes/share-for-the-Home/backup/backup-oc-2023/backup/pictures_rsync >> ~/log/backup.log
rsync -avp ~/Documents/documentsPersonal /Volumes/share-for-the-Home/backup/backup-oc-2023/backup/documents_rsync >> ~/log/backup.log

echo "*********** Ending Backup Task - " $date " - Rsync Of Folders Complete ***********"