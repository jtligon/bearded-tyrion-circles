#!/bin/sh

if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
ring_col=`echo Black`
meter_col=`echo Black`
out=`echo  /tmp/nday-ring.png`
 
d=`cal \`date '+%m'\` \`date '+%Y'\` | grep . | fmt -1 | tail -1`
p=`date +"%d"`


x=`echo 360 / $d | bc`;z=`echo "${x} * ${p}" | bc`;y=`echo "-90 + $z" | bc`;
if [ "$p" != "$d" ]
then
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${y}" $out
else
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 0,360" $out
fi
echo "\033[1;39m${p}\033[0m\c"
printf " "
