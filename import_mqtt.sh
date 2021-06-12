# *********
# Mi Body Composition Scale 2 Garmin Connect v1.6
# *********

# Data acquisition from MQTT broker
user=admin
passwd=password
host=host_name
path=/home/robert

# Create file with data
read_MQTT=`mosquitto_sub -h $host -t 'data' -u $user -P $passwd -C 1 | awk -F "\"*,\"*" 'END{print $5}'`
if [ -f $path/data/export_$read_MQTT.log ] ; then
	echo 'This data has already been exported'
elif [ -f $path/data/import_$read_MQTT.log ] ; then
	echo 'This import file already exists'
else
	mosquitto_sub -h $host -t 'data' -u $user -P $passwd -C 1 > $path/data/import_$read_MQTT.log
	sed -i '1iWeight,Impedance,Units,User,Unix_time,Readable_time,Bat_in_V,Bat_in_%' $path/data/import_$read_MQTT.log
fi

# Calculate data and export to Garmin Connect, logging, handling errors, backup file
if [ -f $path/data/import_* ] ; then
	python3 $path/export_garmin.py > $path/data/temp.log 2>&1
	move=`awk -F "_" '/Processed file: import/{print $2}' $path/data/temp.log`
	if grep -q 'Error' $path/data/temp.log ; then
		echo 'Errors have been detected'
	elif grep -q 'panic' $path/data/temp.log ; then
		echo 'Errors have been detected'
	elif grep -q 'denied' $path/data/temp.log ; then
		echo 'Errors have been detected'
	else
		mv $path/data/import_$move $path/data/export_$move
	fi
fi