#!/bin/bash

# declare drive mount and place variable
SSD="/mnt/ssd/"
DISC="/dev/sda1/"

# checking that $SSD have files
x=$(ls $SSD | wc -l)

if [ 1 -gt $x  ]
then
    #mounting ssd
    echo "SSD is NOT mounted"
    mount $DISC $SSD
fi

$(yunohost backup create --apps)




    
