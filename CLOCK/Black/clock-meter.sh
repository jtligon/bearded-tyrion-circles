analog=`cat ~/Documents/CIRCLE/CONFIG | grep 'CLOCK_DIGITAL' | tail -n1 | awk '{print $2}'`
if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
out=`echo  /tmp/clock-ring.png` 
ring_col=`echo black`
s_meter_col=`echo black`
m_meter_col=`echo black`
h_meter_col=`echo black`

ds=`date +"%S"`
dm=`date +"%M"`
dh=`date +"%k"`;
if [ "$dh" -gt "12" ]
then
let dh=$dh-12;
fi
z=`echo "6 * ${ds}" | bc`;s=`echo "-90 + $z" | bc`;
z=`echo "6 * ${dm}" | bc`;m=`echo "-90 + $z" | bc`;
z=`echo "30 * ${dh}" | bc`;h=`echo "-90 + $z" | bc`;
$convert -size 200x200 xc:transparent -stroke ${ring_col} -strokewidth 10 -fill none -draw "arc 190,190 10,10 0,360" $out
if [ "$s" != "-90" ]
then
	$convert $out -fill none -stroke ${s_meter_col} -strokewidth 10 -draw "arc 170,170 30,30 -90,${s}" $out
fi
if [ "$m" != "-90" ]
then
	$convert $out -fill none -stroke ${m_meter_col} -strokewidth 10 -draw "arc 150,150 50,50 -90,${m}" $out
fi
if [ "$h" = "-90" ]
then
	$convert $out -fill none -stroke ${h_meter_col} -strokewidth 10 -draw "arc 130,130 70,70 0,360" $out 
else
	$convert $out -fill none -stroke ${h_meter_col} -strokewidth 10 -draw "arc 130,130 70,70 -90,${h}" $out
fi

x=`date +"%k:%M:%S";`

echo "\033[1;39m${x}\033[0m\c"
printf " "
