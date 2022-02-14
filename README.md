1.  Add an new user
    sudo adduser malaw
    Add additional details as requested
2.  Add this user to adm group
    sudo gpasswd -a malaw adm
3.  Add this user to sudo group
    sudo gpasswd -a malaw sudo
4.  Important Check if you are able to login using this account
    ssh <username>@<pi-address>
    If you are able to successfully login, ONLY THEN proceed to the next steps
    Ensure that you are in the sudoers group by issuing this command
    sudo whoami
    Should return that you are 'root'
5.  Lock the 'pi' account on the Raspberry pi
    sudo passwd -l pi
6.  Next, let us not use any password for the user we created
    sudo visudo
    and add this <username> ALL=(ALL) NOPASSWD:ALL
7.  Next, let us automate the upgrades on the RaspberryPi
    Install the unattended-upgrades package
    sudo apt-get install unattended-upgrades
    Edit the unattended upgrades conf file
    sudoedit /etc/apt/apt.conf.d/50unattended-upgrades
    Locate this line
    "origin=Debian,codename=${distro_codename},label=Debian-Security";
        And Add this after that line
            "origin=Raspbian,codename=${distro_codename},label=Raspbian";
    "origin=Raspberry Pi Foundation,codename=\${distro_codename},label=Raspberry Pi Foundation";
8.  Next, let us disable the services that we are not using
    First, let us list all the services that are running now on the Pi
    systemctl --type=service --state=active
    Since my Pi is connected over a LAN Cable, i can disable it by
    sudo systemctl disable wpa_supplicant.service
    Likewise disable all unused services
9.  Next, let us install firewall on the Pi, follow the steps in order or you will mess up
    sudo apt-get install ufw
    sudo ufw allow 22/tcp comment "SSH"
    sudo ufw allow samba
    sudo ufw enable
10. Allow only one user to ssh to your box
    sudoedit /etc/ssh/sshd_config
    Add this line under Authentication section just above #PubkeyAuthentication yes
    AllowUsers malaw
11. Install fail2ban to stop bruteforce attack on Pi
    sudo apt-get install fail2ban
    sudoedit /etc/fail2ban/jail.local
    And add this to the file
    [DEFAULT]
    bantime = 1h
    banaction = ufw

    [sshd]
    enabled = true
    sudo systemctl enable --now fail2ban
    sudo systemctl restart sshd
