#!/bin/bash
# Author: Hartl Sascha

defaultPrivateKey="./private_key.pem"
defaultPublicKey="./public_key.pem"

# Ask for the path of the encrypted archive to restore
echo "Enter path to the encrypted archive to restore:"
read encryptedArchive

# Ask for the path to the public key for signature verification (default is ./public_key.pem)
echo "Enter path to your public key for signature verification (default: $defaultPublicKey):"
read publicKey
publicKey=${publicKey:-$defaultPublicKey}

# Ask for the path to the private key for decryption (default is ./private_key.pem)
echo "Enter path to your private key for decryption (default: $defaultPrivateKey):"
read privateKey
privateKey=${privateKey:-$defaultPrivateKey}

# Check if the specified private key exists
if [ ! -f "$privateKey" ]; then
    echo "Error: Private key '$privateKey' not found. Exiting."
    exit 1
fi

# Check if the specified public key exists
if [ ! -f "$publicKey" ]; then
    echo "Error: Public key '$publicKey' not found. Exiting."
    exit 1
fi

# Ask for the password for decryption
echo "Enter password for decryption:"
read -s password

# Verify the signature of the encrypted file
openssl dgst -sha256 -verify "$publicKey" -signature "${encryptedArchive}.sig" "$encryptedArchive"
if [ $? -eq 0 ]; then
    echo "Signature is valid"
else
    echo "Signature is invalid"
    exit 1
fi

# Decrypt the encrypted archive file
decryptedArchive="${encryptedArchive%.enc}"
openssl enc -d -aes-256-cbc -in "$encryptedArchive" -out "$decryptedArchive" -pass pass:"$password"

# Extract the decrypted archive
echo "Extracting the decrypted archive..."
tar -xzvf "$decryptedArchive" -C /tmp

echo "Backup restored successfully."
