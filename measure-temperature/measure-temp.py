from gpiozero import CPUTemperature
from time import sleep, strftime, time

cpu = CPUTemperature()
temp = cpu.temperature

temperature_data = [
    {
        "measurement" : "temperature",
        "tags" : {
            "host": "RaspberryPiNas"
        },
        "fields" : {
            "temperature": float(temp)
        }
    }
]

def write_temp(temp):
    with open("/home/username/cpu_temp.csv", "a") as log:
        log.write("{0},{1}\n".format(strftime("%Y-%m-%d %H:%M:%S"),str(temp)))

write_temp(temp)