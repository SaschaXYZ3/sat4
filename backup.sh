#!/bin/bash
#Hartl Sascha

#variables
outputDirectory="/tmp"
currentDate=$(date +"%Y-%m-%d-%H:%M:%S")
outputFile="backup_${USER}_${currentDate}.tar.gz"
outputArchive="${outputDirectory}/${outputFile}"

# user input for backup directory
echo "Enter directory to backup"
read backupDirectory

createBackup(){
# create a archive of the given directory and print the file information
    tar -czvf $outputArchive $backupDirectory 2> /dev/null
    echo "backup created and stored in ${outputDirectory} as ${outputFile}"
    echo "ls ${outputDirectory}"
    ls -la $outputArchive
}

createBackup