# Capture your WAN IP using the shell script (capture-your-wan-ip.sh) and let it send an email when the WAN IP Address changes. Install mailutils to send email from the Raspberry Pi

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
```bash
# Shutdown at 10:45
45 22 * * * sudo shutdown -h now
# Check WAN IP Everyday At Six
0 6 * * * <Path to the file to execute> >><Path to the log file> 2>&1
```