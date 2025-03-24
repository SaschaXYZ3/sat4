# README

#### Author: Hartl Sascha

## Description

This script is designed to create backups of specified directories, encrypt those backups, and sign them. Additionally, the script compares the number of files and directories in the original folder with those in the archive to ensure the backup's integrity. The script also allows multiple directories to be backed up sequentially and counts the archived files and directories. A separate script is provided to decrypt and verify the encrypted and signed backups.

## Features

1. **Backup Creation**: Compresses the specified directory into a .tar.gz archive.
2. **Integrity Check**: Compares the number of files and directories in the original directory and the archive to ensure the backup's accuracy.
3. **Encryption**: Encrypts the archive using AES-256-CBC with a user-provided password.
4. **Multiple Backups** : Allows multiple directories to be backed up sequentially and keeps count of archived files and directories.
5. **Signing**: Signs the encrypted archive with a private key to ensure authenticity and integrity.
6. **Decryption and Verification**: A separate script decrypts the encrypted backup, verifies the signature, and extracts the archive to the desired directory.

## Requirements

- OpenSSL must be installed.
- A public-private key pair is required.
- If you don’t have a key pair, you can generate one with the following command:

  ```bash
  openssl genpkey -algorithm RSA -out private_key.pem && openssl rsa -in private_key.pem -pubout -out public_key.pem
  writing RSA key
  ```

## Usage

### Encryption

1. **Make the script executable**
   ```bash
   chmod +x backup.sh
   ```
2. **Run the backup script**
   ```bash
   ./backup.sh
   ```
3. **Enter the directory to back up**
   If no directory is entered, the default is the logged-in user's home directory.
   ```bash
   Enter directory to backup, if no directory is entered the default is your home directory
   <path/to/directory>
   ```
4. **Safe backup with password**
   ```bash
   Enter password for encryption:
   ```
5. **Sign backup with key**
   ```bash
   Enter path to your private key for signing, if no key is entered the default is ./private_key.pem
   ```
6. **Add another backup?**
   If you want to back up another directory, answer with "y".
   ```bash
   Do you want to backup another directory? (y/n)
   y
   ```

### Decryption

1. **Make the script executable**
   ```bash
   chmod +x restore_backup.sh
   ```
2. **Run the backup script**
   ```bash
   ./restore_backup.sh
   ```
3. **Path to encrypted archive**
   ```bash
   Enter path to the encrypted archive to restore:
   ```
4. **Path to signed archive**
   ```bash
   Enter path to the signature archive to restore:
   ```
5. **Path to public key for verification**
   ```bash
   Enter path to your public key for signature verification (default: ./public_key.pem):
   ```
6. **Path to private key for decryption**
   ```bash
   Enter path to your private key for decryption (default: ./private_key.pem):
   ```
7. **Password for decryption**
   ```bash
   Enter password for decryption:
   ```

## Examples

### Encryption

```bash
./backup.sh
Enter directory to backup, if no directory is entered the default is your home directory

No directory specified. Using default directory: /home/user
/home/user/
/home/user/.bash_history
/home/user/.gnupg/
/home/user/.gnupg/pubring.kbx
/home/user/.gnupg/private-keys-v1.d/
/home/user/.bashrc
/home/user/.cache/
/home/user/.cache/motd.legal-displayed
/home/user/.bash_logout
/home/user/test/
/home/user/test/test.txt
/home/user/.profile
/home/user/.Xauthority
/home/user/.viminfo
/home/user/sat4/
/home/user/sat4/private_key.pem
/home/user/sat4/restore_backup.sh
/home/user/sat4/backup.sh
/home/user/sat4/public_key.pem
/home/user/.sudo_as_admin_successful
/home/user/.ssh/
/home/user/.ssh/authorized_keys
Backup of /home/user completed successfully!
Enter password for encryption:
Encrypting of /home/user completed successfully!
Enter path to your private key for signing, if no key is entered the default is ./private_key.pem

-rw-rw-r-- 1 user user 8096 Mar 24 19:12 /tmp/backup_user_2025-03-24-19:12:17.tar.gz.enc
Signing of /home/user completed successfully!
Do you want to backup another directory? (y/n)

Number of archived files: 15
Number of archived directories: 7
Number of created archivs: 1
END

END
```

### Decryption

```bash
./restore_backup.sh
Enter path to the encrypted archive to restore:
/tmp/backup_user_2025-03-24-19:12:17.tar.gz.enc
Enter path to the signature archive to restore:
/tmp/backup_user_2025-03-24-19:12:17.tar.gz.sig
Enter path to your public key for signature verification (default: ./public_key.pem):

Enter path to your private key for decryption (default: ./private_key.pem):

Enter password for decryption:
Verified OK
Signature is valid
Extracting the decrypted archive...
home/user/
home/user/.bash_history
home/user/.gnupg/
home/user/.gnupg/pubring.kbx
home/user/.gnupg/private-keys-v1.d/
home/user/.bashrc
home/user/.cache/
home/user/.cache/motd.legal-displayed
home/user/.bash_logout
home/user/test/
home/user/test/test.txt
home/user/.profile
home/user/.Xauthority
home/user/.viminfo
home/user/sat4/
home/user/sat4/private_key.pem
home/user/sat4/restore_backup.sh
home/user/sat4/backup.sh
home/user/sat4/public_key.pem
home/user/.sudo_as_admin_successful
home/user/.ssh/
home/user/.ssh/authorized_keys
Backup restored successfully.

```
