#!/bin/bash

# It is only for Yunohost https://yunohost.org/ar/backup
# declare drive mount and place variables
SSD="/mnt/ssd/"
DISC="/dev/sda1"
BACKUP_DIRECTORY="/mnt/ssd/backup/"
# LOG_FILE="/mnt/ssd/backup/logfile"
CURRENT_DATE=$(date "+%Y%m%d-%H%M")

# checking that $SSD have files
isDriveMounted=$(ls $SSD | wc -l)
FAIL_STRING=$(echo "mount: /mnt: special device /dev/sda1 does not exist.")

if [ 1 -gt $isDriveMounted ]
then
    #mounting ssd
    echo "SSD is NOT mounted"

    isReallyMounted=$(mount $DISC $SSD) #if empty, drive is mounted
    isDriveAvailable=$(echo $isReallyMounted)

    if [[ $FAIL_STRING == $isDriveAvailable ]]
    then
        #ssd is not connected to computer
        echo "Drive is not connected. Breaking!"
        exit 0
    fi    
fi

#creating new directory for the backup
mkdir $BACKUP_DIRECTORY$CURRENT_DATE

# Creating backup

echo "Creating backup"
# echo "Creating backup" >> $LOG_FILE
# backuping only hedgedoc, gitea, wallabag2 and droppy
yunohost backup create --apps wallabag2 hedgedoc gitea droppy -o $BACKUP_DIRECTORY$CURRENT_DATE
echo "Backup created"
# echo "Backup created" >> $LOG_FILE

# for deleting old files, older than 20 days 
find $BACKUP_DIRECTORY -mtime +20 -type f -delete