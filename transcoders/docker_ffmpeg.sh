#! /bin/sh

for var in "$@"
do
	case "$string" in
	*ffmpeg*)
		;;
	*)
	  	string="${string} \"$var\""
	  	stringf="${stringf} $var"
	  	;;
    esac
done
(
sleep 10000
echo "killed"
wget -q 172.17.0.1:9998/stop/$$ --post-data="$string" -O /tmp/$$ &
) &
case "$string" in
	*USERNAME*)
		wget -q 172.17.0.1:9998/start/$$ --post-data="$string" -O /tmp/$$ &
        read -n 1 userInput
        wget -q 172.17.0.1:9998/stop/$$ --post-data="$string" -O /tmp/$$ &
        echo "killed"
		;;
	*998*)
		wget -q 172.17.0.1:9998/start/$$ --post-data="$string" -O /tmp/$$ &
        read -n 1 userInput
        wget -q 172.17.0.1:9998/stop/$$ --post-data="$string" -O /tmp/$$ &
        echo "killed"
		;;
	*)
		/bin/ffmpeg.oem $stringf
		;;
esac

