#!/bin/bash

DVD_DEVICE=$(/usr/bin/drutil status | /usr/bin/grep '/dev/disk' | /usr/bin/cut -d ':' -f3)
echo "DVD_DEVICE: $DVD_DEVICE"

LONGEST_TITLE=$(/usr/local/bin/mplayer -ni -dvd-device $DVD_DEVICE -nocache -identify dvd:// -frames 0 | /usr/bin/grep '_LENGTH=' | /usr/local/bin/gawk 'match($0, /TITLE_(.*)_LENGTH=(.*)$/, ary) && ary[2] > max_time { max_time = ary[2];  longest_title = ary[1] } END { print longest_title }')
echo "LONGEST_TITLE: $LONGEST_TITLE"

DISK_IDENTIFIER=$(/bin/echo "$DVD_DEVICE" | /usr/bin/cut -d '/' -f3)
echo "DISK_IDENTIFIER: $DISK_IDENTIFIER"

MOVIE_NAME=$(/usr/sbin/diskutil list | /usr/bin/grep " $DISK_IDENTIFIER" | /usr/bin/tr -s ' ' | /usr/bin/cut -d ' ' -f3)
echo "MOVIE_NAME: $MOVIE_NAME"

DUMP_FILE=/tmp/"$MOVIE_NAME".mkv
echo "DUMP_FILE: $DUMP_FILE"

FINAL_FILE=/Volumes/Media/Movies/"$MOVIE_NAME".mkv
echo "FINAL_FILE: $FINAL_FILE"

/usr/local/bin/mplayer -ni -dumpstream dvd://"$LONGEST_TITLE" -nocache -dvd-device $DVD_DEVICE -dumpfile "$DUMP_FILE"
/usr/local/bin/mkvmerge "$DUMP_FILE" --output "$FINAL_FILE" && rm "$DUMP_FILE"

/usr/bin/drutil tray eject
/usr/bin/say "Hey Dan, I am done ripping your DVD"

