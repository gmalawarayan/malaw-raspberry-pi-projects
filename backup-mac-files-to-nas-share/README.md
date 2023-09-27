# Rsync Mac Folders to NAS Shares

Bash Script to take backup of your folders in Mac

Ensure "Full Disk Access" is granted to the Cron, Shell, Terminal and CronTab programs

Go to Security & Privacy Preferences > Privacy and click Full Disk Access from the left panel and use CMD + SHIFT + G to bring up the "Go To" Menu and choose the programs

Ensure "Login Items" has the folders for the NAS Shares - mounting the NAS Share on MacOs - Check this on the internet

## Set it as Cron Entry to run the shell script everyday

```bash
0 6 * * * <Path to the file to execute> >><Path to the log file> 2>&1
```