# Monitor, Record and Visualize your internet speed using speedTest, influxDB and Grafana

### Install dependencies for running SpeedTest Cli
```bash
sudo apt install apt-transport-https gnupg1 dirmngr lsb-release
```
Add SpeedTest GPG Key
```bash
curl -L https://packagecloud.io/ookla/speedtest-cli/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/speedtestcli-archive-keyring.gpg >/dev/null
```
### Install Speed Test CLI
```bash
sudo apt-get install speedtest-cli
```
Copy the script speedTest.py into the file
```bash
nano speedtest.py
```
Install Python Library for InfluxDB Connectivity
```bash
sudo apt install python3-influxdb
```

## Install Influx Database

Use apt-get to install influx DB
```bash
sudo apt-get install influxdb
```

Configure InfluxDB to run when system starts
```bash
sudo systemctl unmask influxdb
```
```bash
sudo systemctl enable influxdb
```
Start the influx DB
```bash
sudo systemctl start influxdb
```
Check its status 
```bash
sudo systemctl status influxdb
```

Check the connectivity by installing InfluxDB Client
```bash
sudo apt install influxdb-client
```
Use the command to connect
```bash
influx 
```

Use the below commands to create Database 
```bash
CREATE DATABASE internetspeed
CREATE USER "speedmonitor" WITH PASSWORD '<password>'
GRANT ALL ON "internetspeed" to "speedmonitor"
```

## Install Grafana for visualizing

Install GPG Key For Grafana
```bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
```
Add Grafana Package to Sources List
```bash
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```
Update apt-get
```bash
sudo apt-get update
```
Install Grafana using apt-get
```bash
sudo apt-get install -y grafana
```
Enable Grafana to start on system startup
```bash
sudo /bin/systemctl enable grafana-server
```
Start Grafana
```bash
sudo /bin/systemctl start grafana-server
```
Allow Grafana to be accessible through UFW Rule
```bash
sudo ufw allow 3000/tcp
```
Restart Grafana if you want to
```bash
sudo systemctl restart grafana-server
```

## Configure Crontab

Add below Crontab Emtry to run Python Script every 30 minutes
```bash
# 30 minute monitor of internet speed for recording it in influx db for visualizing it in grafana
*/30 * * * * python3 <full path and file name of the script> >> <full path and file name of the log file> 2>&1
```