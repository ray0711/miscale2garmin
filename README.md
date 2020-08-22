# Mi Body Composition Scale 2 Garmin Connect

## 1. Introduction
This project is based on the following projects:
- https://github.com/rando-calrissian/esp32_xiaomi_mi_2_hass
- https://github.com/lolouk44/xiaomi_mi_scale
- https://github.com/davidkroell/bodycomposition

It allows the Mi Body Composition Scale 2 to be fully automatic synchronized to Garmin Connect.

## 2. How does this work?
 - after weighing, Mi Body Composition Scale 2 is active for 15 minutes on bluetooth transmission;
 - the ESP32 module every 5 minutes (deep sleep is used) queries scale for data, the process can be started immediately via the reset button;
 - the ESP32 module sends the acquired data via the MQTT protocol to the MQTT broker installed on the server;
 - the body weight and impedance data on the server are appropriately processed by scripts;
 - the processed data are sent by the program bodycomposition to Garmin Connect;
 - raw data from the scale is backed up on the server (renamed to export_file).
 
## 3. Bluetooth gateway to WiFi (via MQTT) on ESP32
Use the Arduino environment to compile and upload software to ESP32.

In Arduino, select the WEMOS LOLIN32 board and set the parameters:
- CPU Frequency: "80MHz (WiFi / BT)" for better energy saving;
- Partition Scheme: "No OTA (Large APP)";
- Port: "COM" on which ESP32 board is detected;

The following information must be entered before compiling the code:
- scale's mac address, it can be read from the Mi Fit application ("scale_mac_addr");
- parameters of your WiFi network ("ssid", "password", "ip", "gateway", "subnet");
- connection parameters MQTT ("mqtt_server", "mqtt_port", "mqtt_userName", "mqtt_userPass").

## 4. Preparing Linux system
