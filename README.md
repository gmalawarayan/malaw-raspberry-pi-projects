# Instructions to Secure Your RaspberryPi

## Add an new user other than default pi user

```bash
    sudo adduser <username>
    Add additional details as requested
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

## Disable the services that you are not using

First, list all the services that are running now on the Pi

```bash
    systemctl --type=service --state=active
```

If Pi is connected over a LAN Cable, disable wifi by using this command

```bash
    sudo systemctl disable wpa_supplicant.service
```

Likewise disable all unused services

## Install firewall on the Pi, follow the steps in order or you will mess up

```bash
    sudo apt-get install ufw
    sudo ufw allow 22/tcp comment "SSH"
    sudo ufw allow samba
    sudo ufw enable

```

## Allow only one user to ssh to your box

```bash
    sudoedit /etc/ssh/sshd_config
```

Add this line under Authentication section just above 

```
    #PubkeyAuthentication yes
```

```
    AllowUsers <newly created username>
```

## Install fail2ban to stop bruteforce attack on your Raspberry Pi

```bash
    sudo apt-get install fail2ban
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
    sudo systemctl restart sshd
```

## Check the logs if there is a daily update of upgrades happening as per configuration

```bash
    cat /var/log/unattended-upgrades/unattended-upgrades.log
```