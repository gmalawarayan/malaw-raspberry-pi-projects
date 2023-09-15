import os
import re
import subprocess
import time
from influxdb import InfluxDBClient

response = subprocess.Popen('speedtest --secure', shell=True, stdout=subprocess.PIPE, text=True).stdout.read()
ping = re.search(':\s+(.*?)\s', response, re.MULTILINE)
download = re.search('Download:\s+(.*?)\s', response, re.MULTILINE)
upload = re.search('Upload:\s+(.*?)\s', response, re.MULTILINE)

ping = ping.group(1)
download = download.group(1)
upload = upload.group(1)

speed_data = [
    {
        "measurement" : "internet_speed",
        "tags" : {
            "host": "RaspberryPiNas"
        },
        "fields" : {
            "download": float(download),
            "upload": float(upload),
            "ping": float(ping)
        }
    }
]

client = InfluxDBClient('localhost', 8086, 'speedmonitor', 'inter@123', 'internetspeed')

client.write_points(speed_data)

try:
    f = open('./speedtest.csv', 'a+')
    if os.stat('./speedtest.csv').st_size == 0:
            f.write('Date,Time,Ping (ms),Download (Mbps),Upload (Mbps)\r\n')
    else:
            f.write('{},{},{},{},{}\r\n'.format(time.strftime('%m/%d/%y'), time.strftime('%H:%M'), ping, download, upload))
finally:
    f.close()