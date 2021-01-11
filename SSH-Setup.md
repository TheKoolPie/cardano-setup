# Setup SSH Key
To easily and securly connect to cloud pc, we use SSH Keys. We need to setup the target cloud server and our own machine. **NEVER** the offline machine.
([Tutorial](https://upcloud.com/community/tutorials/use-ssh-keys-authentication/))

## Prepare Cloud machine
Connect to cloud machine via username + password.
```cli
ssh username@server-ip
```
Create ssh directory and set permissions.
```cli
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```
## Generate key on your machine
Create your ssh locally
```cli
ssh-keygen -t rsa
```
Optionally enter a passphrase, this is recommended. This will be your password for connecting to the server in the future
## Copy key to cloud machine
The following command assumes you used all the standard settings while generating your ssh key. If not you'll have to change the parameters in your command to your changes to the standard settings.
```cli 
ssh-copy-id -i ~/.ssh/id_rsa.pub username@server-ip
```
## Connect to server
Now you can again connect to your cloud machine using: 
```cli
ssh username@server-ip
```
This command now should prompt you for your ssh keyphrase.