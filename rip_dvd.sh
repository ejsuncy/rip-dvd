#!/bin/bash

DVD_DEVICE=$(/usr/bin/drutil status | /usr/bin/grep '/dev/disk' | cut -d ':' -f3)

LONGEST_TITLE=$(/usr/local/bin/mplayer -dvd-device $DVD_DEVICE -nocache -identify dvdnav:// -frames 0 | /usr/bin/grep '_LENGTH=' | /usr/local/bin/gawk 'match($0, /TITLE_(.*)_LENGTH=(.*)$/, ary) && ary[2] > max_time { max_time = ary[2];  longest_title = ary[1] } END { print longest_title }')

DISK_IDENTIFIER=$(/bin/echo $DVD_DEVICE | cut -d '/' -f3)

MOVIE_NAME=$(/usr/sbin/diskutil list | /usr/bin/grep " $DISK_IDENTIFIER" | /usr/bin/tr -s ' ' | /usr/bin/cut -d ' ' -f3)

DUMP_FILE=/Volumes/Seagate\ Expansion/Movies/$MOVIE_NAME.mkv

/usr/local/bin/mplayer -dumpstream dvdnav://$LONGEST_TITLE -nocache -dvd-device $DVD_DEVICE -dumpfile "$DUMP_FILE"
/usr/bin/drutil tray eject
/usr/bin/say "Hey Dan, I am done ripping your DVD"

