# README

# Hartl Sascha

## reuirements

openssl must be installed
you need a Public Private keypair
if you dont have one create it with

```bash
openssl genpkey -algorithm RSA -out private_key.pem && openssl rsa -in private_key.pem -pubout -out public_key.pem
writing RSA key
```

1. **make script runable**
   ```bash
   chmod +x backup.sh
   ```
2. **run backup.sh**
   ```bash
   ./backup.sh
   ```
3. **enter directory to backup**
   If no directory is enterd the default is the logged in users home directory

   ```bash
   Enter directory to backup, if no directory is entered the default is your home directory
   <path/to/directory>
   ```

4. **another run?**
   If you want to backup another directory answer with "y"
   ```bash
   Do you want to backup another directory? (y/n)
   y
   ```

## Example

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
/home/user/sat4/backup.sh
/home/user/sat4/public_key.pem
/home/user/.sudo_as_admin_successful
/home/user/.ssh/
/home/user/.ssh/authorized_keys
Backup of /home/user completed successfully!
Enter password for encryption:
Encrypting of /home/user completed successfully!
Enter path to your private key for signing, if no key is entered the default is ./private_key.pem

pkeyutl: Use -help for summary.
Signing of /home/user completed successfully!
Do you want to backup another directory? (y/n)
n
Number of archived files: 14
Number of archived directories: 7
Number of created archivs: 1
END
```
