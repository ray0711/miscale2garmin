# Mi Body Composition Scale 2 Garmin Connect

## 1. How does this work?

This project is based on the following projects:

https://github.com/rando-calrissian/esp32_xiaomi_mi_2_hass

https://github.com/lolouk44/xiaomi_mi_scale

https://github.com/davidkroell/bodycomposition

It allows the Mi Body Composition Scale 2 to be fully automatic synchronized to Garmin Connect.

After weighing, scale is active for 15 minutes on bluetooth transmission.

The ESP32 module every 5 minutes (deep sleep is used) queries Mi Body Composition Scale 2 for data, the process can be started immediately via the reset button.

The ESP32 module sends the acquired data via the MQTT protocol to the MQTT broker installed on the server.

The body weight and impedance data on the server are appropriately processed by scripts.

The processed data are sent by the program body composition to Garmin Connect.

Raw data from the scale is backed up on the server.

## 2. Bluetooth gateway to WiFi (MQTT) on ESP32

## 3. Preparing Linux system
