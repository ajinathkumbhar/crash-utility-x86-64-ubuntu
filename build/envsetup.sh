CURRPATH=$(pwd)
NDKBIN="${CURRPATH}/prebuilt/linux-x86_64/bin"
GDBCORESCRIPT="${CURRPATH}/build/scripts/"

if [ ! -d $NDKBIN ]; then
	echo 
	echo "Check ndk bins : $NDKBIN"
	echo 
	return
fi

if [ ! -d $GDBCORESCRIPT ]; then
	echo 
	echo "Check gdb-core script : $GDBCORESCRIPT"
	echo 
	return
fi

export PATH=$PATH:${NDKBIN}:${GDBCORESCRIPT}




