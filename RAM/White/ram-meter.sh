#!/bin/sh 
if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi

ring_col=white
meter_col=white
out=/tmp/ram-ring.png
used_ram=`top -l 1 | awk '/PhysMem/ {print $2}' | sed "s/M//"`
free_ram=`top -l 1 | awk '/PhysMem/ {print $6}' | sed "s/M//"`


if [ `echo $free_ram | grep -c "G" ` != 0 ]
then
i=`echo ${#free_ram}`;let y=$i-1;
free_ram=`echo ${free_ram:0:$y}`
let free_ram=$free_ram*1024
fi

let total_ram=$((used_ram+free_ram))

used_percent=$(echo "scale=2; $used_ram / $total_ram * 100" | bc)
used_percent=`echo $used_percent | cut -d . -f 1`
free_ram=$(echo "scale=2; $free_ram / 1024" | bc)

	
p=`echo $used_percent`
z=`echo "3.6 * ${p}" | bc`
y=`echo "-90 + $z" | bc`;
if [ "$p" = "100" ]
then
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 0,${y}" $out
elif [ "$p" = "0" ]
then
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" $out
else
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${y}" $out
fi
echo "\033[1;37mRAM\033[0m\c"
printf "\n"	
echo "\033[1;37m${p}%\033[0m\c"
printf " "