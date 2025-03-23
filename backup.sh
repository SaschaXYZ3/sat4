#!/bin/bash
#Hartl Sascha

#variables
currentDate=$(date +"%Y-%m-%d-%H:%M:%S")
#outputFile="backup_${USER}_${currentDate}.tar.gz"
outputArchive="/tmp/backup_${USER}_${currentDate}.tar.gz"
defaultDirectory="/home/$USER"

counterFiles=0
counterDirs=0
counterArchiveFiles=0

defaultKey="./private_key.pem"


createBackup(){
    # count files before backup
    filesBefore=$(nrFiles $backupDirectory)
    dirsBefore=$(nrDirectories $backupDirectory)

    # create a archive of the given directory and print the file information
    tar -czvf $outputArchive $backupDirectory 2> /dev/null

    compareDirectoriesAgainstArchive

    signAndEncrypt

    rm $outputArchive

    let counterFiles=$((numberFilesInDir))+$counterFiles
    let counterDirs=$((numberDirsInDir))+$counterDirs
    let counterArchivFiles++
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

signAndEncrypt() {
    echo "Enter password for encryption:"
    read -s password
    openssl enc -aes-256-cbc -salt -in "${outputArchive}" -out "${outputArchive}.enc" -pass $password 2> /dev/null
    echo "Encrypting of ${backupDirectory} completed successfully!"
    echo "Enter path to your private key for signing, if no key is entered the default is ${defaultKey}"
    read privateKey
    openssl pkeyutl -rawin -sign -in ${outputArchive}.enc -inkey "${privateKey:-$defaultKey}" -out "${outputArchive}.sig"
    echo "Signing of ${backupDirectory} completed successfully!"
}

# user input for backup directory
echo "Enter directory to backup, if no directory is entered the default is your home directory"
read inputDirectory

if [ -z "${inputDirectory}" ]; then
    echo "No directory specified. Using default directory: ${defaultDirectory}"
fi

backupDirectory=${inputDirectory:-$defaultDirectory}

createBackup

# ask if the user wants to backup another directory (Loops & Arithemtics)
echo "Do you want to backup another directory? (y/n)"
read answer

while [ "$answer" == "y" ]
do
    echo "Please enter directory to backup:"
    read newInputDirrectory

    if [ -d "$newInputDirrectory" ]
    then
        backupDirectory=$newInputDirrectory
        currentDate=$(date +"%Y-%m-%d-%H:%M:%S")
        #outputFile="backup_${USER}_${currentDate}.tar.gz"
        outputArchive="/tmp/backup_${USER}_${currentDate}.tar.gz"
        createBackup
    else
        echo "Directory $newInputDirrectory does not exist."
    fi

    echo "Do you want to backup another directory? (y/n)"
    read answer
done

# print the number of files, directories and created archives
echo "Number of archived files: $counterFiles"
echo "Number of archived directories: $counterDirs"
echo "Number of created archivs: $counterArchivFiles"

echo "END"