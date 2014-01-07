if [ `which composite | grep -c "composite"` != 0 ]
then
composite=`which composite`
else
composite=`cat ~/Documents/CIRCLE/CONFIG | grep 'COMPOSITE_PATH' | tail -n1 | awk '{print $2}'`;
fi
if [ `which convert | grep -c "convert"` != 0 ]
then
convert=`which convert`
else
convert=`cat ~/Documents/CIRCLE/CONFIG | grep 'CONVERT_PATH' | tail -n1 | awk '{print $2}'`;
fi
theme=`cat ~/Documents/CIRCLE/CONFIG | grep 'ITUNES_THEME' | tail -n1 | awk '{print $2}'`
itnsps=`osascript -e "tell application \"System Events\"" -e "if (exists application process \"iTunes\") then" -e "return \"yes\"" -e "else" -e "return \"no\"" -e "end if" -e "end tell"`
lasttrack=`tail /tmp/itunestrack`
tcover=`echo /tmp/iTunes-Cover-c.png`
cover=`echo ~/Documents/CIRCLE/ITUNES/iTunes-Cover.png`
out=`echo /tmp/iTunes-stat-c.png`
tmp=`echo /tmp/iTunes-stat-c-tmp.png`
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
				echo "   \033[1;7m${track}   \033[0m\c"
				printf "\n"
					if [ "$album" != "" ]
					then
						echo "   \033[1;7m${album}   \033[0m\c"
						printf "\n"
					else 
					echo "   \033[1;7mUNKNOW   \033[0m\c"
					printf "\n"
					fi
					if [ "$artist" != "" ]
					then
						echo "   \033[1;7m${artist}   \033[0m\c"
						printf " "
					else 
						echo "   \033[1;7mUNKNOW   \033[0m\c"
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
 					
 					mv $cover $tcover
				else
					cp -r ~/Documents/CIRCLE/ITUNES/$theme/default.png $tcover
				fi
			fi
			if [ -f $tcover ]
			then
				h=`sips --getProperty pixelHeight $tcover | tail -n1 | awk '{print $2}'`
				x=`sips --getProperty pixelWidth $tcover | tail -n1 | awk '{print $2}'`
				if [ $h -gt $x ]
				then
				ix="${x}"
				elif [ $h -lt $x ]
				then
					xix="${h}"
				elif [ $x -eq $h ]
					then
						xix="${h}"
					fi
				$convert $tcover -crop ${xix}x${xix}+0+0 +repage $tmp
				$convert $tmp -resize 200x $tmp
				$convert $tcover -resize 700x $out 
				if [ $h -lt 300 ]
				then
					$convert $out -resize x300 $out
				fi
				$convert $out -crop 700x300+0+0 +repage $out
				if [ "$itnesstat" = "0" ]
				then
					let xp=$itnesstat+1
				else
					let xp=$itnesstat+0
				fi 
				let perc=$xp*7
				$composite -geometry -230 -gravity center $tmp $out $out
				$convert $out -size 700x300  -stroke white -strokewidth 20 -draw "stroke-linecap square   path 'M 0,290 L 700,290'" -stroke black -strokewidth 20 -draw "stroke-linecap square   path 'M 0,290 L ${perc},290'" $out

				
			fi
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
