#!/usr/local/bin/python3

import Xiaomi_Scale_Body_Metrics
import os
import glob
import datetime
import sys
import paho.mqtt.client as mqtt
import threading

last_weight=None
last_impedance=None
lock = threading.Lock()

def age(birthdate):
    today = datetime.date.today()
    calc_date = datetime.datetime.strptime(birthdate, "%d-%m-%Y")
    return (today.year - calc_date.year - ((today.month, today.day) < ( calc_date.month, calc_date.day)))

def on_message_weight(client, userdata, message):
    global last_weight
    print("received weight=", str(message.payload.decode("utf-8")))
    last_weight=float(message.payload.decode("utf-8"))
    upload()

def on_message_impedance(client, userdata, message):
    global last_impedance
    print("received impedance=", str(message.payload.decode("utf-8")))
    last_impedance=float(message.payload.decode("utf-8"))
    upload()

def upload():
    print("lock aqcuire")
    print(lock.acquire())
    global last_weight
    global last_impedance
    if last_weight is not None and last_impedance is not None:
        print("Uploading...")    
        lib = Xiaomi_Scale_Body_Metrics.bodyMetrics(last_weight, int(os.environ["HEIGHT"]), age(os.environ["BIRTHDATE"]), os.environ["SEX"], int(last_impedance))
        print("weight=", last_weight)
        print("bone=", lib.getBoneMass())
        print("fat=", lib.getFatPercentage())
        print("bmi=", lib.getBMI())
        print("mAge", lib.getMetabolicAge())

        bone_percentage = (lib.getBoneMass() / last_weight) * 100
        muscle_percentage = (lib.getMuscleMass() / last_weight) * 100
        message = './bodycomposition upload '
        message += '--bone ' + "{:.2f}".format(bone_percentage) + ' '
        message += '--calories ' + "{:.2f}".format(lib.getBMR()) + ' '
        message += '--email ' + os.environ["GARMIN_EMAIL"] + ' '
        message += '--fat ' + "{:.2f}".format(lib.getFatPercentage()) + ' '
        message += '--hydration ' + "{:.2f}".format(lib.getWaterPercentage()) + ' '
        message += '--metabolic-age ' + "{:.0f}".format(lib.getMetabolicAge()) + ' '
        message += '--muscle ' + "{:.2f}".format(muscle_percentage) + ' '
        message += '--password ' + os.environ["GARMIN_PASSWORD"] + ' '
        message += '--physique-rating ' + "{:.2f}".format(lib.getBodyType()) + ' '
        message += '--unix-timestamp ' + str(int(datetime.datetime.now().timestamp())) + ' '
        message += '--visceral-fat ' + "{:.2f}".format(lib.getVisceralFat()) + ' '
        message += '--weight ' + "{:.2f}".format(last_weight) + ' '
        message += '--max-tries 1'
        print(message)
        os.system(message)
        print("done")

        # reset
        last_weight=None
        last_impedance=None

    lock.release()
    print("lock released")

client = mqtt.Client("GarminConnectUploader")
client.connect(os.environ["MQTT_HOST"])
client.message_callback_add("scale/sensor/weight_raimund/state", on_message_weight)
client.message_callback_add("scale/sensor/impedance_raimund/state", on_message_impedance)

client.subscribe([(os.environ["TOPIC_WEIGHT"],0), (os.environ["TOPIC_IMPEDANCE"], 0)])
client.message_callback_add("scale/sensor/weight_raimund/state", on_message_weight)
client.message_callback_add("scale/sensor/impedance_raimund/state", on_message_impedance)
client.loop_forever()
