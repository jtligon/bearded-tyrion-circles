if [ `which composite | grep -c "composite"` != 0 ]
then
composite=`which composite`
else
composite=`cat ~/Documents/CIRCLE/CONFIG | grep 'COMPOSITE_PATH' | tail -n1 | awk '{print $2}'`;
fi
cover=`echo ~/Documents/CIRCLE/ITUNES/iTunes-Cover.png`
tcover=`echo /tmp/iTunes-Cover-c.png`
img=`echo ~/Documents/CIRCLE/ITUNES/iTunes-stat-c.png`
tmp=`echo /tmp/iTunes-stat-c-tmp.png`
out=`echo /tmp/iTunes-stat-c.png`
if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
theme=`cat ~/Documents/CIRCLE/CONFIG | grep 'ITUNES_THEME' | tail -n1 | awk '{print $2}'`
itnsps=`osascript -e "tell application \"System Events\"" -e "if (exists application process \"iTunes\") then" -e "return \"yes\"" -e "else" -e "return \"no\"" -e "end if" -e "end tell"`
lasttrack=`tail /tmp/itunestrack`


if [ "$itnsps" = "yes" ] 
then 
itnsplst=`osascript -e "tell application \"iTunes\"" -e "return (get player state as string)" -e "end tell"`

		if [ "$itnsplst" = "playing" ] 
		then
			track=`osascript -e "tell application \"iTunes\"" -e "set curTrack to current track" -e "name of curTrack as string" -e "end tell"`
			album=`osascript -e "tell application \"iTunes\"" -e "set curTrack to current track" -e "album of curTrack as string" -e "end tell"`
			artist=`osascript -e "tell application \"iTunes\"" -e "set curTrack to current track" -e "artist of curTrack as string" -e "end tell"`
			itnesstat=`osascript -e "tell application \"iTunes\"" -e "set trackname to name of current track" -e "set trackduration to duration of current track" -e "set trackposition to player position" -e "set elapsed to round (trackposition / trackduration * 100)" -e "set output to elapsed" -e "end tell"`
			if [ "$track" != "" ]
				then
				echo "\033[1;39m${track}   \033[0m\c"
				printf "\n"
					if [ "$album" != "" ]
					then
						echo "\033[1;39m${album}   \033[0m\c"
						printf "\n"
					else 
					echo "\033[1;39mUNKNOW   \033[0m\c"
					printf "\n"
					fi
					if [ "$artist" != "" ]
					then
						echo "\033[1;39m${artist}   \033[0m\c"
						printf " "
					else 
						echo "\033[1;39mUNKNOW   \033[0m\c"
						printf " "
					fi
				fi
			playtrack=`echo $track-$artist-$album-$theme`;
			if [ "$lasttrack" != "$playtrack" ]
			then
				echo $track-$artist-$album-$theme > /tmp/itunestrack
				osascript -e "set myPath to ((path to home folder) as text) & \"Documents:\" & \"CIRCLE:\" & \"ITUNES:\"" -e "set artworkItunes to POSIX path of myPath & \"iTunes-Cover.png\"" -e "set defaultPic to POSIX path of myPath & \"default.png\"" -e "tell application \"iTunes\"" -e "set artData to data of artwork 1 of current track" -e "set fileRef to (open for access artworkItunes with write permission)" -e "try" -e "write artData to fileRef starting at 0" -e "close access fileRef" -e "on error" -e "try" -e "close access fileRef" -e "end try" -e "error" -e "end try" -e "end tell"
				if [ -f $cover ]
				then			    
					h=`sips --getProperty pixelHeight $cover | tail -n1 | awk '{print $2}'`
					x=`sips --getProperty pixelWidth $cover | tail -n1 | awk '{print $2}'`
					if [ $h -gt $x ]
					then
						ix="${x}"
					elif [ $h -lt $x ]
					then
						ix="${h}"
					elif [ $x -eq $h ]
					then
						ix="${h}"
					fi
					$convert $cover -gravity Top -crop ${ix}x${ix}+0+0 +repage $cover
					$convert $cover -resize 180x $cover 
					$convert -size 180x180 xc:none -fill $cover  -draw "circle 90,90 90,1" $cover  
					$convert -size 700x300  xc:transparent -stroke none -fill white -draw "arc 230,260 10,40 0,360" -stroke none -fill White -draw "arc 470,260 690,40 0,360" -fill white -draw "rectangle 120,260 580,40" -stroke darkgray -strokewidth 20 -draw "stroke-linecap square   path 'M 230,230 L 470,230'" -fill darkgray -stroke none  -draw "arc 210,220 230,240 0,360" -fill darkgray -stroke none  -draw "arc 470,220 490,240 0,360" $img
					$composite -geometry +230 -gravity center $cover $img $img
					$composite -geometry -230 -gravity center ~/Documents/CIRCLE/ITUNES/$theme/vinyl.png $img $img
					rm -rf $cover
 				else 
 					$convert ~/Documents/CIRCLE/ITUNES/$theme/default.png -resize 180x $tcover
					$convert -size 180x180 xc:none -fill $tcover  -draw "circle 90,90 90,1" $tcover  
					$convert -size 700x300  xc:transparent -stroke none -fill white -draw "arc 230,260 10,40 0,360" -stroke none -fill White -draw "arc 470,260 690,40 0,360" -fill white -draw "rectangle 120,260 580,40" -stroke darkgray -strokewidth 20 -draw "stroke-linecap square   path 'M 230,230 L 470,230'" -fill darkgray -stroke none  -draw "arc 210,220 230,240 0,360" -fill darkgray -stroke none  -draw "arc 470,220 490,240 0,360" $img
					$composite -geometry +230 -gravity center $tcover $img $img
					$composite -geometry -230 -gravity center ~/Documents/CIRCLE/ITUNES/$theme/vinyl.png $img $img
 
				fi

			fi
			
			ss=`echo 230`
			y=`echo 2.4*$itnesstat | bc`;wx=`echo $y + $ss | bc`
			ae=`echo $wx + 30 | bc`; 
			$convert $img -size 700x300   -fill lightgray -stroke none  -draw "arc 210,220 230,240 0,360" -stroke lightgray -strokewidth 20 -draw "stroke-linecap square   path 'M 230,230 L ${wx},230'" -fill lightgray -stroke gray -strokewidth 2  -draw "arc ${wx},215 ${ae},245 0,360" $tmp
			mv $tmp $out
		else
			if [ "$lasttrack" != "" ]
			then
				$convert -size 1x1 xc:transparent $out
				echo "" > /tmp/itunestrack
			fi
		fi
		
else
	if [ "$lasttrack" != "" ]
	then
		$convert -size 1x1 xc:transparent $out
		echo "" > /tmp/itunestrack
	fi
fi
