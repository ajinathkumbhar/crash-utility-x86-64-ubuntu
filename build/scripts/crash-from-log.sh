
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


function file_dir_check() {

if [ $2 -eq 1 ]; then
	if [ ! -f $1 ] ;then
		error "File does't exits : $1"
	fi
else
	if [ ! -f $1 ] ;then
		error "Dir does't exits : $1"
	fi
fi
}


SYMB_PATH=$1
LOGCAT=$2

	if [ -z "$SYMB_PATH" ]; then
		error
		echo " Usages: crash-from-log.sh  <symbol path>  <logcat file>"
		echo "-----------------------------------------------------------------"
		echo 
		exit
	fi

	if [ -z "$LOGCAT" ]; then
		error
		echo " Usages: crash-from-log.sh  <symbol path>  <logcat file>"
		echo "-----------------------------------------------------------------"
		echo 
		exit
	fi


VENDORLIB=$(cat $LOGCAT |grep DEBUG |grep /system/vendor/lib* )
LIB=$(cat $LOGCAT |grep DEBUG |grep /system/lib/*  )

if [ "$VENDORLIB" != "" ] ; then
	echo "found vendor lib"
	SMB_PATH="$SYMB_PATH/system/vendor/lib/"
else
	echo "found system lib"
	SMB_PATH="$SYMB_PATH/system/lib/"
fi




	if [ ! -d "$SMB_PATH" ]; then
		error "Please check symbol path : $SMB_PATH"
		exit
	fi

ndk-stack -sym $SMB_PATH -dump $LOGCAT



