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
    # count files before backup
    files=$(nrFiles $backupDirectory)
    dirs=$(nrDirectories $backupDirectory)

    # create a archive of the given directory and print the file information
    tar -czvf $outputArchive $backupDirectory
    echo "Backup from ${backupDirectory} with ${files} files and ${dirs} directories created and stored in ${outputDirectory} as ${outputFile}"
    echo "ls ${outputArchive}"
    ls -la $outputArchive


}

# functions from 2
nrFiles() {
    find "$1" -type f | wc -l 2> /dev/null
}

nrDirectories() {
    find "$1" -type d | wc -l 2> /dev/null
}

createBackup