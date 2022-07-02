#!/bin/bash

# It is only for Yunohost https://yunohost.org/ar/backup
# declare drive mount and place variables
SSD="/mnt/ssd/"
DISC="/dev/sda1"
BACKUP_DIRECTORY="/mnt/ssd/backup/"
LOG_FILE="/mnt/ssd/logfiles/logfile.txt"
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

echo "$CURRENT_DATE Creating backup" >> $LOG_FILE
# echo "Creating backup" >> $LOG_FILE
# backuping only hedgedoc, gitea, wallabag2 and droppy
yunohost backup create --apps wallabag2 hedgedoc droppy -o $BACKUP_DIRECTORY$CURRENT_DATE
if [ $? -eq 0 ]; then
    echo "$CURRENT_DATE Backup created" >> $LOG_FILE
else
    echo "$CURRENT_DATE Backup NOT created" >> $LOG_FILE

# for deleting old files, older than 20 days 
find $BACKUP_DIRECTORY -mtime +20 -type f -delete
if [ $? -eq 0 ]; then
    echo "$CURRENT_DATE Old files deleted" >> $LOG_FILE
else
    echo "$CURRENT_DATE Old files NOT deleted" >> $LOG_FILE
# For deleting symlinks for old backups. It is required to show backups in webadmin panel
find /home/yunohost.backup/archives/ -mtime +20 -type l -delete
if [ $? -eq 0 ]; then
    echo "$CURRENT_DATE Old symlinks deleted" >> $LOG_FILE
else
    echo "$CURRENT_DATE Old symlinks NOT deleted" >> $LOG_FILE