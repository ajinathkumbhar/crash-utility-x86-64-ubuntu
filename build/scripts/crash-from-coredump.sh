#!/bin/bash
# TODO:

function start(){
echo "-----------------------------------------------------------------
  			    G D B   
----------------------------------------------------------------"
}

function error() {

echo "-----------------------------------------------------------------
		   E R R O R  !!!!!!
----------------------------------------------------------------"

}

function gdbwrapper()
{
    local GDB_CMD="$1"
    shift 1
    $GDB_CMD -x "$@"
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]: } " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            exit
            ;;
    esac
}

function gdbclient() {
local PROCESS_PATH=$1
local SYMB_PATH=$2
local CORE_DUMP=$3

	if [ -z "$SYMB_PATH" ]; then
		error
		echo " Usages: crash-from-coredump.sh  <process path in device>  <symbol path> "
		echo "       : For process name check 'adb logcat' with DEBUG tag"
		echo "-----------------------------------------------------------------"
		echo 
		return -1
	fi

	if [ -z "$PROCESS_PATH" ]; then
		error
		echo " Usages: crash-from-coredump.sh  <process path in device>  <symbol path> "
		echo "       : For process name check 'adb logcat' with DEBUG tag"
		echo "-----------------------------------------------------------------"
		echo 
		return -1
	fi



local OUT_ROOT=$(pwd)
local SYMBOLS_DIR=$SYMB_PATH
local LOCAL_EXE_PATH=$SYMBOLS_DIR/$PROCESS_PATH
local USE64BIT=""

	if [ ! -f $LOCAL_EXE_PATH ]; then
		error
		echo "Error: unable to find symbols for executable file $LOCAL_EXE_PATH does not exist"
	fi

	if [[ "$(file $LOCAL_EXE_PATH)" =~ 64-bit ]]; then
		USE64BIT="64"
	fi

local GDB=$OUT_ROOT/arm-gdb-tool/gdb-orig
local OUT_SO_SYMBOLS=$SYMBOLS_DIR/system/lib$USE64BIT
local OUT_VENDOR_SO_SYMBOLS=$SYMBOLS_DIR/vendor/lib$USE64BIT
local ART_CMD=""

local SOLIB_SYSROOT=$SYMBOLS_DIR
local SOLIB_SEARCHPATH=$OUT_SO_SYMBOLS:$OUT_SO_SYMBOLS/hw:$OUT_SO_SYMBOLS/ssl/engines:$OUT_SO_SYMBOLS/drm:$OUT_SO_SYMBOLS/egl:$OUT_SO_SYMBOLS/soundfx:$OUT_VENDOR_SO_SYMBOLS:$OUT_VENDOR_SO_SYMBOLS/hw:$OUT_VENDOR_SO_SYMBOLS/egl

	if [ ! -f $OUT_ROOT/gdbshell.cmds ];then
		rm $OUT_ROOT/gdbshell.cmds
	fi

	echo >|"$OUT_ROOT/gdbshell.cmds" "set solib-absolute-prefix $SOLIB_SYSROOT"
	echo >>"$OUT_ROOT/gdbshell.cmds" "set solib-search-path $SOLIB_SEARCHPATH"
	if [ ! -z $CORE_DUMP ];then
	echo >>"$OUT_ROOT/gdbshell.cmds" "core-file $CORE_DUMP"
	fi
	echo >>"$OUT_ROOT/gdbshell.cmds" ""
	start
	echo "Process Name      :  $PROCESS_PATH"
	echo "Symbols Path      :  $SYMB_PATH"
	if [ ! -z $CRASH_DUMP ];then
		echo "Process Core dump :  $CORE_DUMP"
	fi
	echo "gdbshell.cmds     :"
	echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	cat $OUT_ROOT/gdbshell.cmds
	echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo 
	confirm
	start
	gdbwrapper $GDB "$OUT_ROOT/gdbshell.cmds" "$LOCAL_EXE_PATH"
}

gdbclient $*
