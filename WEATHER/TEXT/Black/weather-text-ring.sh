#!/bin/sh

ring_col=`echo Black`
if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
c=`cat ~/Documents/CIRCLE/CONFIG | grep 'WEATHER_CODE' | tail -n1 | awk '{print $2}'`;
url=`echo "http://xml.weather.yahoo.com/forecastrss?p=$c&u=c"`;
strx=`curl --silent "$url" | grep -E '(Current Conditions:|C<BR)' | sed -e 's/Current Conditions://' -e 's/<br \/>//' -e 's/<b>//' -e 's/<\/b>//' -e 's/<BR \/>//' -e 's/<description>//' -e 's/<\/description>//' -e 's/,//' | tail -n1 | tr '[:lower:]' '[:upper:]'`;i=`echo ${#strx}`;let y=$i-4;
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360"  /tmp/weather-ring.png
echo "\033[1;39m${strx:0:$y}\033[0m\c"
printf "\n"	
