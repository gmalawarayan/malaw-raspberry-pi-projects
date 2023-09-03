# Secure Your RaspberryPi

## Add an new user other than default pi user and add additional details as requested
```bash
sudo adduser <username>
```

## Add this user to adm (Admin) Group

```bash
sudo gpasswd -a <newly created username> adm
```

## Add this user to sudo group

```bash
sudo gpasswd -a <newly created username> sudo
```

## Important Check if you are able to login using this account

```bash
ssh <newly created username>@<pi-address>
```

If you are able to successfully login, ONLY THEN proceed to the next steps
Ensure that you are in the sudoers group by issuing this command

```bash
sudo whoami
```

Should return that you are 'root'

## Lock the 'pi' account on the Raspberry pi

```bash
sudo passwd -l pi
```

## Let us not use any password for the user we created

```bash
sudo visudo
```

and add this line

```bash
<username> ALL=(ALL) NOPASSWD:ALL
```

## Password Less Entry into your Raspberry Pi
### Create the ssh key pair and follow the instructions from the command

```bash
ssh-keygen -t ed25519 -C "<comments>"
```
### Add the ssh public key generated to the authorized key file

```bash
ssh-copy-id -i ~/.ssh/<ssh-key>.pub -f <username>@<host-ip-address-or-hostname>
```

Alternatively, if there are many pub files for some reasons

```bash
cat ~/.ssh/id_rsa.pub | ssh <USERNAME>@<IP-ADDRESS> 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys'
```
Another means of installing authorized keys 

```bash 
sudo install -d -m 700 ~/.ssh
```
```bash
sudo nano ~/.ssh/authorized_keys
```
And manually copy and paste the public key
```bash
sudo chmod 644 ~/.ssh/authorized_keys
```
```bash
sudo chown <username>:<usergroup> ~/.ssh/authorized_keys
```

## Automate the upgrades on the RaspberryPi

Install the unattended-upgrades package

```bash
sudo apt-get install unattended-upgrades
```

Edit the unattended upgrades conf file

```bash
sudoedit /etc/apt/apt.conf.d/50unattended-upgrades
```

Locate this line

```
    "origin=Debian,codename=${distro_codename},label=Debian-Security";
```

And Add this after that line

```
"origin=Raspbian,codename=${distro_codename},label=Raspbian";
"origin=Raspberry Pi Foundation,codename=\${distro_codename},label=Raspberry Pi Foundation";
```
Save and exit the file.
Check if the configuration of unattended upgrades by using the below command.

```bash
sudo unattended-upgrades -d
```
To Check the logs if daily upgrades are working as configured

```bash
cat /var/log/unattended-upgrades/unattended-upgrades.log
```

You will also need to install power-management tool in order for Raspberry Pi to check if Raspberry Pi is on battery or on power to install the upgrades automatically. Install the package by using the command below.

```bash
sudo apt-get install powermgmt-base
```

## Disable the services that you are not using

First, list all the services that are running now on the Pi

```bash
sudo systemctl --type=service --state=active
```

If RaspberryPi is connected over a LAN Cable, disable WiFi by using this command

```bash
sudo systemctl disable wpa_supplicant.service
```

Likewise disable all unused services

## Install firewall on the Pi, follow the steps in order or you will mess up

```bash
sudo apt-get install ufw
```
```bash
sudo ufw allow 22/tcp comment "SSH"
```
```bash
sudo ufw allow samba
```
```bash
sudo ufw enable
```

## Allow only one user to ssh to your box

```bash
sudoedit /etc/ssh/sshd_config
```

Add this line under Authentication section just above "#PubkeyAuthentication yes"

```
AllowUsers <newly created username>
```

PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no

Save and exit the file

## Install fail2ban to stop bruteforce attack on your Raspberry Pi

```bash
sudo apt-get install fail2ban
```
```bash
sudoedit /etc/fail2ban/jail.local
```
And add this to the file

[DEFAULT]
bantime = 1h
banaction = ufw

[sshd]
enabled = true

```bash
sudo systemctl enable --now fail2ban
```
```bash
sudo systemctl restart sshd
```

## Install samba server to serve as NAS on your Raspberry Pi

Create the folder to be shared, this shared folder should be mounted with the external hard drive

```bash
mkdir -p <path-to-the-folder-to-be-shared>
```

List the disks attached by their UUID
```bash
sudo ls -l /dev/disk/by-uuid/
```

```bash
sudo nano /etc/fstab
```

Add this line to the file
UUID=<uuid>	<path-to-the-folder-to-be-shared>	<filesystemType>	defaults	0 0

And test the mount configuration by using this command 

```bash
sudo mount -a
```
This should mount or show error, fix the errors 

Install Samba and its dependencies

```bash
sudo apt-get install samba samba-common-bin
```

Edit the Samba Config file

```bash
sudo nano /etc/samba/smb.conf
```

Add this to the file - smb.conf

```bash
    comment = <meaningful comment>
    [<meaningfulfortheshare>]
    path = /<path>/<tothe>/<foldertobeshared>
    writeable=Yes
    create mask=0777
    directory mask=0777
    public=no
```

Add an user to samba to let it access the share

```bash
sudo smbpasswd -a <newly-added-user>
```

Restart the Samba Service and configure firewall to allow incoming traffic

```bash
sudo systemctl restart smbd
```
```bash
sudo ufw allow samba
```

## Capture your WAN IP using the shell script (capture-your-wan-ip.sh) and let it send an email when the WAN IP Address changes. Install mailutils to send email from the Raspberry Pi

```bash
sudo apt-get install ssmtp
```
```bash
sudo apt-get install mailutils
```

## Configure the ssmtp.conf to include your email address and other settings

```bash
    root=postmaster
    mailhub=smtp.gmail.com:587
    hostname=RaspberryPi
    AuthUser=<your email id>
    AuthPass=<Go to Google Account Setting and Configure Password for APP and insert here>
    FromLineOverride=YES
    UseSTARTTLS=YES
```

## Set it as Cron Entry to run the shell script everyday in the morning - refer to capture-your-wan-ip.sh

```bash
0 6 * * * /<Path to the file to execute>
```

## Install Avahi on to RaspberryPi to ping / login using a hostname rather than IP address

```bash
sudo apt-get install avahi-daemon
```

After installing do update to run the service on boot up

```bash
sudo update-rc.d avahi-daemon defaults
```

Check what is the current hostname by using this command

```bash
hostname
```

You can edit / change the hostname by using this command

```bash
sudo /etc/hostname
```

RaspberryPi will now be discoverable by the hostname appended with ".local" like "raspberrypi.local"
