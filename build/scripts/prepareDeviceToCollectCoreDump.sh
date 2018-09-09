
#!/bin/bash

function start(){
echo "-----------------------------------------------------------------
  			    G D B   
----------------------------------------------------------------"
}

function error() {

echo "-----------------------------------------------------------------"
echo "			E R R O R  !!!!!!"
echo "		$1"
echo "-----------------------------------------------------------------"

}
function info() {

echo "-----------------------------------------------------------------"
echo "	N O T E :"
echo "		 $1"
echo "-----------------------------------------------------------------"

}


# ensure adb server is started
adb start-server

# check if device is connected
ARR_DETECTED=$(adb devices | head -n -1 | tail -n +2 | tr '\t' '|')

if [ "$ARR_DETECTED" == "" ] ;then
	error  "Device connection error. check adb devices"

	zenity --error --title="${TITLE}" --text="There isn't any device connected in ADB mode"; exit 1; 
	exit
fi
# if no device connected, error message
[ "${#ARR_DETECTED[@]}" -eq "0" ] && { zenity --error --title="${TITLE}" --text="There isn't any device connected in ADB mode"; exit 1; }

# check debug build to set properties 
DEBUGBUILD=$(adb shell getprop ro.debuggable)
if [ "$DEBUGBUILD" != "1" ]; then
	error "adb root failed. Use debug build" 
	exit
fi
info "Please wait until device reboot and don't disconnect usb connection"
adb root
sleep 2
adb shell setprop persist.debug.trace 1
echo -n "persist.debug.trace : "
adb shell getprop persist.debug.trace
adb reboot
adb wait-for-device
sleep 5
adb root
sleep 5
adb shell setenforce 0
echo -n "persist.debug.trace : "
adb shell getprop persist.debug.trace
echo -n "Selinux             : "
adb shell getenforce 
