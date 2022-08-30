#!/bin/bash

DATE=$(date +%Y-%m-%d-%H-%M)
DATADIR=/root/.near/data
BACKUPDIR=/root/.near/backups

mkdir $BACKUPDIR

sudo systemctl stop neard

wait

echo "NEAR node was stopped"

if [ -d "$BACKUPDIR" ]; then
    echo "Backup started"

        #check for older backups
        count=`ls -1 ${BACKUPDIR}/*.tar.gz 2>/dev/null | wc -l`
        if [ $count != 0 ]
        then
                #remove oldes backup
                rm "$(ls -t ${BACKUPDIR}/*.tar.gz | tail -1)"
        fi

    #archive data
    tar -zcf ${BACKUPDIR}/near_${DATE}.tar.gz $DATADIR

   # cp -rf $DATADIR/data/ ${BACKUPDIR}/

    # Submit backup completion status, you can use healthchecks.io, betteruptime.com or other services

    echo "Backup completed"
else
    echo $BACKUPDIR is not created. Check your permissions.
    exit 0
fi

sudo systemctl restart neard

echo "NEAR node was started" 
