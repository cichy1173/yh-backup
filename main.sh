#!/bin/bash

# It is only for Yunohost https://yunohost.org/ar/backup
# declare drive mount and place variables
SSD="/mnt/ssd/"
DISC="/dev/sda1/"
BACKUP_DIRECTORY="/mnt/ssd/backup/"

# checking that $SSD have files
x=$(ls $SSD | wc -l)

if [ 1 -gt $x ]
then
    #mounting ssd
    echo "SSD is NOT mounted"
    mount $DISC $SSD
fi

# Creating backup of entire system
$(yunohost backup create -o $BACKUP_DIRECTORY)