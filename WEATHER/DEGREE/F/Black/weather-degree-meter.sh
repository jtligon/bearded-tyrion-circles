#!/bin/sh

if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
ring_col=`echo Black`
meter_col=`echo Black`
out=`echo  /tmp/weather-degree-ring.png` 
c=`cat ~/Documents/CIRCLE/CONFIG | grep 'WEATHER_CODE' | tail -n1 | awk '{print $2}'`;
f=`cat ~/Documents/CIRCLE/CONFIG | grep 'WEATHER_FORMATT' | tail -n1 | awk '{print $2}'`;
f=`echo $f | tr '[:upper:]' '[:lower:]';`
url=`echo "http://xml.weather.yahoo.com/forecastrss?p=$c&u=$f"`;
temp=`curl --silent ${url} | grep -E '(Current Conditions:|F<BR)' | sed -e 's/Current Conditions://' -e 's/<br \/>//' -e 's/<b>//' -e 's/<\/b>//' -e 's/<BR \/>//' -e 's/<description>//' -e 's/<\/description>//' -e 's/,//' | tail -n1 | perl -wane 'print $F[-2]'`;
if [ `echo $temp | grep -c "-" ` != 0 ]
then
i=`echo ${#temp}`;let y=$i-1;
m=`echo ${temp:1:$y}`
p=`echo $temp`
z=`echo "3 * ${m}" | bc`;x=`echo "90 - $z" | bc`;y=`echo "180 + $x" | bc`;
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 ${y},-90" $out
else
p=`echo $temp`
z=`echo "3 * ${p}" | bc`;y=`echo "-90 + $z" | bc`;
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" -fill none -stroke ${meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${y}" $out
fi

i=`awk 'BEGIN { print "\xc2\xb0\F"; }'`
	
printf " "
if [ "$p" != "" ]
then
echo "\033[1;39m${p}${i}\033[0m\c"
printf "\n"
fi












