# Mi Body Composition Scale 2 Garmin Connect

## 1. Introduction
This project is based on the following projects:
- https://github.com/rando-calrissian/esp32_xiaomi_mi_2_hass
- https://github.com/lolouk44/xiaomi_mi_scale
- https://github.com/davidkroell/bodycomposition

It allows the Mi Body Composition Scale 2 to be fully automatic synchronized to Garmin Connect.

## 2. How does this work?
 - after weighing, Mi Body Composition Scale 2 is active for 15 minutes on bluetooth transmission;
 - ESP32 module operates in a deep sleep and wakes up every 5 minutes, queries scale for data, the process can be started immediately via the reset button;
 - the ESP32 module sends the acquired data via the MQTT protocol to the MQTT broker installed on the server;
 - the body weight and impedance data on the server are appropriately processed by scripts;
 - the processed data are sent by the program bodycomposition to Garmin Connect;
 - raw data from the scale is backed up on the server (renamed to export_file).
 
## 3. Bluetooth gateway to WiFi (via MQTT) on ESP32
Use the Arduino environment to compile and upload software to ESP32.

In Arduino, select the WEMOS LOLIN32 board and set the parameters:
- CPU Frequency: "80MHz (WiFi / BT)" for better energy saving;
- Partition Scheme: "No OTA (Large APP)";
- Port: "COM" on which ESP32 board is detected.

The following information must be entered before compiling the code:
- scale's mac address, it can be read from the Mi Fit application ("scale_mac_addr");
- parameters of your WiFi network ("ssid", "password", "ip", "gateway", "subnet");
- connection parameters MQTT ("mqtt_server", "mqtt_port", "mqtt_userName", "mqtt_userPass").

Debug and other comments:
- the project is prepared to work with the ESP32 board with the charging module (red LED indicates charging). I based my version on the LI-Ion 18650 battery;
- program for ESP32 has implemented UART debug mode, you can verify if everything is working properly;
- after switching the device on, blue LED will light up for a moment to indicate that the module has started successfully;
- if the data are acquired correctly in the next step, the blue LED will flash for a moment 2 times;
- if there is an error, e.g. the data is incomplete, no connection to the WiFi network or the MQTT broker, the blue LED will light up for 5 seconds;
- the program implements the battery level and voltage measurement (beta version), which are sent together with the scale data in topic MQTT;
- the device has 2 buttons, the first green is the reset button (monostable), the red one is the battery power switch (bistable).

## 4. Preparing Linux system
It is based on a Debian Buster virtual machine. I prefer the minimal version with an ssh server (Net Install).

