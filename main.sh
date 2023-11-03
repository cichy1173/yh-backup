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
FAIL_STRING=$(echo "mount: /mnt: special device $DISC does not exist.")

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

# for deleting old files, older than 9 days 
find $BACKUP_DIRECTORY -mtime +5 -type f -delete

# For deleting symlinks for old backups. It is required to show backups in webadmin panel
find /home/yunohost.backup/archives/ -mtime +5 -type l -delete

# For deleting old backups, including backups of apps (pre-upgrade backups)
find  /home/yunohost.backup/archives/ -mtime +5 -type f -delete

#creating new directory for the backup
mkdir $BACKUP_DIRECTORY$CURRENT_DATE

# Creating backup

echo "Creating backup"

# backuping all system
yunohost backup create -o $BACKUP_DIRECTORY$CURRENT_DATE
# Create backup of external matrix for Nextcloud
tar cvf - /mnt/raid1/Nextcloud_photos | pigz > $BACKUP_DIRECTORY/raid1_NC_$(date +\%Y\%m\%d).tar.xz
echo "Backup created"
# echo "Backup created" >> $LOG_FILE