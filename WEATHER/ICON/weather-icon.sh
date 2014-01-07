if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
ring_col=`cat ~/Documents/CIRCLE/CONFIG | grep 'WEATHER_ICON_RING_COLOR' | tail -n1 | awk '{print $2}'`
icon_col=`cat ~/Documents/CIRCLE/CONFIG | grep 'WEATHER_ICON_COLOR' | tail -n1 | awk '{print $2}'`
c=`cat ~/Documents/CIRCLE/CONFIG | grep 'WEATHER_CODE' | tail -n1 | awk '{print $2}'`;
url=`echo "http://xml.weather.yahoo.com/forecastrss?p=$c&u=c"`;
tx=`curl --silent "$url" | grep  '/us/we/52/' | tail -n1 | awk '{print $2}'`;i=`echo ${#tx}`;let y=$i-10;let z=$y-36;n=`echo ${tx:36:$z}`;
img=`echo ~/Documents/CIRCLE/WEATHER/ICON/IMAGES/White/$n.png`
out=`echo /tmp/weather-icons.png`

if [ `echo $icon_col | tr '[:lower:]' '[:upper:]'` != "WHITE" ]
then
$convert \( $img  -alpha extract \) -background ${icon_col} -alpha shape $out
$convert $out -size 100x100 -stroke ${ring_col} -strokewidth 5 -fill none -draw "arc 95,95 5,5 0,360"  $out
elif [ `echo $icon_col | tr '[:lower:]' '[:upper:]'` = "WHITE" ]
then
$convert $img -size 100x100 -stroke ${ring_col} -strokewidth 5 -fill none -draw "arc 95,95 5,5 0,360"  $out
fi
