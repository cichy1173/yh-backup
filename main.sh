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
failString=$(echo "mount: /mnt: special device /dev/sda1 does not exist.")

if [ 1 -gt $isDriveMounted ]
then
    #mounting ssd
    echo "SSD is NOT mounted"

    isReallyMounted=$(mount $DISC $SSD) #if empty, drive is mounted
    isDriveAvailable=$(echo $isReallyMounted)

    if [[ $failString == $isDriveAvailable ]]
    then
        #ssd is not connected to computer
        echo "Drive is not connected. Breaking!"
        exit 0
    fi    
fi

#creating new directory for the backup
mkdir $BACKUP_DIRECTORY$CURRENT_DATE
# for creating directory date "+%Y%m%d"

# Creating backup of entire system

echo "Creating backup"
# echo "Creating backup" >> $LOG_FILE
# backuping only hedgedoc, gitea and droppy apps
yunohost backup create --apps wallabag2 hedgedoc gitea droppy -o $BACKUP_DIRECTORY$CURRENT_DATE
echo "Backup created"
# echo "Backup created" >> $LOG_FILE

# for deleting old files, older than 20 days 
find $BACKUP_DIRECTORY -mtime +20 -type f -delete