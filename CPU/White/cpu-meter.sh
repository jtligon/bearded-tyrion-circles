#!/bin/sh 

convert=`echo /usr/local/bin/convert`

ring_col=white
meter_col=white
out=/tmp/cpu-ring.png

myCPU=`top -l 1 | awk '/CPU usage/ {print $3}' | sed s/%//`
myCPU=`echo "tmp=$myCPU; tmp /= 1; tmp" | bc`

typeset -i b=9

x=`echo $myCPU`

unset myCPU
unset b
			
p=`echo $x`
z=`echo "3.6 * ${p}" | bc`;y=`echo "-90 + $z" | bc`;
if [ "$p" = "100" ]
then
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 0,${y}" $out
elif [ "$p" = "0" ]
then
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" $out
else
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${y}" $out
fi
echo "\033[1;37mCPU\033[0m\c"
printf "\n"	
echo "\033[1;37m${x}%\033[0m\c"
printf " "