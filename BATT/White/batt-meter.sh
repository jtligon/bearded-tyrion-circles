#!/bin/sh

convert=`echo /usr/local/bin/convert`

theme=`cat ~/Documents/CIRCLE/CONFIG | grep 'BATT_THEME' | tail -n1 | awk '{print $2}'`
ring_col=White
meter_col_1=green
meter_col_2=yellow
meter_col_3=red
out=/tmp/batt-ring.png 
used_ram=`top -l 1 | awk '/PhysMem/ {print $8}' | sed "s/M//"`
free_ram=`top -l 1 | awk '/PhysMem/ {print $10}' | sed "s/M//"`

let total_ram=$((used_ram+free_ram))


max_charge=`system_profiler -detailLevel basic SPPowerDataType | grep mAh | grep Capacity | awk '{print $5 }'`
actual_charge=`system_profiler -detailLevel basic SPPowerDataType | grep mAh | grep Remaining | awk '{print $4 }'`

avail=$(echo "scale=2; $actual_charge / $max_charge * 100" | bc)

avail=`echo $avail | cut -d . -f 1`

if [ "$avail" = "" ]
then
avail=90
fi

		
p=$avail
z=`echo "3.6 * ${p}" | bc`;y=`echo "-90 + $z" | bc`;

if [ "$avail" -gt "75" ]
then
	meter_col=$meter_col_1
fi
if [[ "$avail" -gt "25" && "$avail" -le "75" ]]
then
	meter_col=$meter_col_2
fi
if [ "$avail" -le  "25" ]
then
	meter_col=$meter_col_3
fi
if [ "$avail" != "100" ]
then
	$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${y}" $out
fi
if [ "$avail" = "0" ]
then
	$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" $out
fi
if [ "$avail" = "100" ]
then
	$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 0,360" $out
fi


echo "\033[1;37mBATT\033[0m\c"
printf "\n"	
echo "\033[1;37m${p}%\033[0m\c"
printf " "
