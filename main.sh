#!/bin/bash

# It is only for Yunohost https://yunohost.org/ar/backup
# declare drive mount and place variables
SSD="/mnt/ssd/"
DISC="/dev/sda1/"
BACKUP_DIRECTORY="/mnt/ssd/backup/"
LOG_FILE="/mnt/ssd/backup/logfile"

# checking that $SSD have files
x=$(ls $SSD | wc -l)

if [ 1 -gt $x ]
then
    #mounting ssd
    echo "SSD is NOT mounted"
    mount $DISC $SSD
fi

# Creating backup of entire system
# backuppingLog=
echo "Creating backup"
echo "Creating backup" >> $LOG_FILE
# backuping only hedgedoc and droppy apps
yunohost backup create --apps hedgedoc droppy -o $BACKUP_DIRECTORY
echo "Backup created"
echo "Backup created" >> $LOG_FILE

# for deleting old files, older than 25 days 
# find $BACKUP_DIRECTORY -mtime +25 -type f -delete