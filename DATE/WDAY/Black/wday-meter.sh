#!/bin/sh

if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
ring_col=`echo black`
meter_col=`echo black`
out=`echo  /tmp/wday-ring.png`
 
d=`date +%a | tr '[:lower:]' '[:upper:]';`
if [ "$d" = "SUN" ]
then
p=`echo 1`
elif [ "$d" = "MON" ]
then
p=`echo 2`
elif [ "$d" = "TUE" ]
then
p=`echo 3`
elif [ "$d" = "WED" ]
then
p=`echo 4`
elif [ "$d" = "THU" ]
then
p=`echo 5`
elif [ "$d" = "FRI" ]
then
p=`echo 6`
elif [ "$d" = "SAT" ]
then
p=`echo 7`
fi
	

x=`echo 360 / 7 | bc`;z=`echo "${x} * ${p}" | bc`;y=`echo "-90 + $z" | bc`;
if [ "$p" != "7" ]
then
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${y}" $out
else
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 0,360" $out
fi
echo "\033[1;39m${d}\033[0m\c"
printf " "
