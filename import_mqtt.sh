# *********
# Mi Body Composition Scale 2 Garmin Connect v1.0
# *********

# Data acquisition from MQTT broker.
user=user
passwd=passwd
host=host

# Create file with data.
mosquitto_sub -h $host -t "data" -u $user -P $passwd -C 1 > temp.log
sed -i '1iWeight,Impedance,Units,User,Timestamp,Bat_in_V, Bat_in_%' temp.log
sed -Ei '2,$ s/(([^,]*,){4})([^,]+)(.*)/echo \x27\1\x27$(date -d "\3" +%s)\x27\4\x27/e' temp.log
rename=`awk -F "\"*,\"*" 'END{print $5}' temp.log`
mv temp.log data/import_$rename.log

if [ -f data/export_$rename.log ]; then
    rm data/import_$rename.log
fi

# Calculate data and export to Garmin Connect.
python3 export_garmin.py