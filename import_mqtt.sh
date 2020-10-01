# *********
# Mi Body Composition Scale 2 Garmin Connect v1.2
# *********

# Data acquisition from MQTT broker
user=admin
passwd=password
host=host_name
path=/home/robert

# Create file with data
mosquitto_sub -h $host -t 'data' -u $user -P $passwd -C 1 > $path/data/temp.log
sed -i '1iWeight,Impedance,Units,User,Timestamp,Bat_in_V,Bat_in_%' $path/data/temp.log
sed -Ei '2,$ s/(([^,]*,){4})([^,]+)(.*)/echo \x27\1\x27$(date -d "\3" +%s)\x27\4\x27/e' $path/data/temp.log
rename=`awk -F "\"*,\"*" 'END{print $5}' $path/data/temp.log`
mv $path/data/temp.log $path/data/import_$rename.log
if [ -f $path/data/export_$rename.log ] ; then
	rm $path/data/import_$rename.log
fi

# Calculate data and export to Garmin Connect
python3 $path/export_garmin.py > $path/data/temp.log 2>&1

# Logging and handling errors
if grep -q 'Error' $path/data/temp.log ; then
	echo 'Errors have been detected'
elif [ -f $path/data/import_$rename.log ] ; then
	mv $path/data/import_$rename.log $path/data/export_$rename.log
else
	echo 'There is no file to export'
fi