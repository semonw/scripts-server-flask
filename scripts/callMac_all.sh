#!/bin/bash
date=`date +%Y%m%d_%H%M%S_%N |cut -b1-20`
dir=log_all_$date
uname=192.168.1.116:5555
time=1s

if [ -L $0 ]
then 
  BASE_DIR=`dirname $(readlink $0)`
else 
  BASE_DIR=`dirname $0`
fi    
basepath=$(cd $BASE_DIR; pwd)
dir=$basepath/../static/logs/$dir

if [ ! -d ${dir} ]
  then
    mkdir $dir
fi

touch keep
adb connect $uname
cnt=0
# downstatus
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | downstatus'

# power on
adb -s $uname shell input keyevent 224
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | power on'

# enter system
adb -s $uname shell input swipe 100 1500 100 100
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | enter system'

# Home Botton
adb -s $uname shell input keyevent 3
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Home Botton'

# Open App
adb -s $uname shell input tap 105 1360
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Open App'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# Open WorkPanel
adb -s $uname shell input tap 660 1700
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# Open Location
adb -s $uname shell input tap 85 510
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Open Location'

# Recall Button
adb -s $uname shell input tap 674 1262
sleep 3s
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Recall Button'

# Enter Button
adb -s $uname shell input tap 540 1350
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Enter Button'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# Home Botton
adb -s $uname shell input keyevent 3
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Home Botton'


# Open App2
adb -s $uname shell input tap 325 1360
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Open App'

# Open App3
adb -s $uname shell input tap 125 1011 
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Open App'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# Open WorkPanel
adb -s $uname shell input tap 660 1700
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# Open Location
adb -s $uname shell input tap 85 510
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Open Location'

# Recall Button
adb -s $uname shell input tap 674 1262
sleep 3s
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Recall Button'

# Enter Button
adb -s $uname shell input tap 540 1350
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Enter Button'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# BackBotton
adb -s $uname shell input tap 63 140
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | BackBotton'

# Home Botton
adb -s $uname shell input keyevent 3
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
echo $cnt' | '$?' | Home Botton'



# Power Off
adb -s $uname shell input keyevent 223
sleep $time
let cnt++
adb -s $uname shell screencap -p /sdcard/MacPro/$cnt.png
adb -s $uname shell dumpsys battery
echo $cnt' | '$?' | Power Off'

for ((i=0; i<=$cnt; i++))
do
 adb -s $uname pull /sdcard/MacPro/$i.png $dir
done
adb disconnect $uname
rm keep
