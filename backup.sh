#!/bin/bash
#Hartl Sascha

#variables
outputDirectory="/tmp"
currentDate=$(date +"%Y-%m-%d-%H:%M:%S")
outputFile="backup_${USER}_${currentDate}.tar.gz"
outputArchive="${outputDirectory}/${outputFile}"
defaultDirectory="/home/$USER"

# user input for backup directory
echo "Enter directory to backup, if no directory is entered the default is your home directory"
read inputDirectory

if [ -z "${inputDirectory}" ]; then
    echo "No directory specified. Using default directory: ${defaultDirectory}"
fi

backupDirectory=${inputDirectory:-$defaultDirectory}

createBackup(){
    # count files before backup
    filesBefore=$(nrFiles $backupDirectory)
    dirsBefore=$(nrDirectories $backupDirectory)

    # create a archive of the given directory and print the file information
    tar -czvf $outputArchive $backupDirectory 2> /dev/null

    compareDirectoriesAgainstArchive

    #echo "Backup from ${backupDirectory} with ${filesBefore} files and ${dirsBefore} directories created and stored in ${outputDirectory} as ${outputFile}"
    echo "ls ${outputArchive}"
    ls -la $outputArchive
}

# functions from 2
nrFiles() {
    find $1 -type f | wc -l 
}

nrDirectories() {
    find $1 -type d | wc -l 
}

nrArchievedFiles() {
    tar -tzf $1 | grep -v /$ | wc -l
}

nrArchivedDirectories() {
    tar -tzf $1 | grep /$ | wc -l
}

compareDirectoriesAgainstArchive(){
    numberFilesInDir=$(nrFiles $backupDirectory)
    numberFilesInArchive=$(nrArchievedFiles $outputArchive)
    numberDirsInDir=$(nrDirectories $backupDirectory)
    numberDirsInArchive=$(nrArchivedDirectories $outputArchive)

    if [ $numberFilesInDir -eq $numberFilesInArchive ] && [ $numberDirsInDir -eq $numberDirsInArchive ]; then
        echo "Backup of ${backupDirectory} completed successfully!"
        return 0
    else
        echo "Backup of ${backupDirectory} failed!"
        exit 1
    fi

}

createBackup