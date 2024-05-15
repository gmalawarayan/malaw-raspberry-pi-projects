#!/bin/bash
# For this script to work, ensure "Login Items" has the folder opened / accessed using "+" sign there. 
# Apple menu > System Preferences > Accounts
# Click on your account in the left column
# Click on "login items"
# Click the + sign
# Select the NAS in the shared servers column in the Finder menu
# Select the folder/volume you want on the NAS and click Add button.

# Function to print the start of a backup task
homeDir="/Users/<username>"
log_file="$homeDir/log/backup.log"
function print_start_backup {
    local date=`date +"%Y-%m-%d %T"`
    echo -e "\n*********** Starting Backup Task today - " $date " - Rsync Of Folders Begin ***********" >> $log_file
}

# Function to check if the log file exists, if not create one
function check_log_file {
    local filename="~/log/backup.log"
    if [ -f $filename ]
    then
        echo "Log file exists"
    else
        touch ~/log/backup.log
    fi
}

# Function to perform the backup
function perform_backup {
    local downloads_source_folder="$homeDir/Downloads/personal/"
    local pictures_source_folder="$homeDir/Pictures/photos/"
    local documents_source_folder="$homeDir/Documents/documentsPersonal/"
    local downloads_destination_folder="/Volumes/<samba-share-drive-folder-path>"
    local pictures_destination_folder="/Volumes/<samba-share-drive-folder-path>"
    local documents_destination_folder="/Volumes/<samba-share-drive-folder-path>"
    local log_file="$homeDir/log/backup.log"

    echo -e "\n*********** Starting Backup of $downloads_source_folder ***********" >> $log_file
    rsync --inplace -avp $downloads_source_folder $destination_folder >> $log_file
    echo -e "\n*********** Complete Backup of $downloads_source_folder ***********" >> $log_file
    echo -e "\n*********** Starting Backup of $pictures_source_folder ***********"  >> $log_file
    rsync --inplace -avp $pictures_source_folder $pictures_destination_folder >> $log_file
    echo -e "\n*********** Complete Backup of $pictures_source_folder ***********" >> $log_file
    echo -e "\n*********** Starting Backup of $documents_source_folder ***********" >> $log_file
    rsync --inplace -avp $documents_source_folder $documents_destination_folder >> $log_file
    echo -e "\n*********** Complete Backup of $documents_source_folder ***********" >> $log_file
}

# Main script
print_start_backup
check_log_file
perform_backup
