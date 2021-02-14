#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
DSET="OneDrive:/"
#-------------------------------------------------------------------
UNZIP_MULTI(){
	temp_fifo="/tmp/$$.fifo"
	mkfifo ${temp_fifo}
	exec 4<>${temp_fifo}
	rm -f ${temp_fifo}
	for ((i=0;i<${1};i++))
	do
    	echo >&4
    done
}
CHECK_ARC(){
	FILE_NAME=${1}
	checkarc=$(file -b ${FILE_NAME}) && checkarc=${checkarc%%\ *}
	case ${checkarc} in
		RAR|rar|Rar|7-zip|7-Zip|7-Z|7-z|7z|7Z|7-ZIP|Zip|ZIP)
		return 1
			;;
		*)
		if [[ ( ${FILE_NAME##*.} == "7z" ) || ( ${FILE_NAME##*.} == "zip" ) || ( ${FILE_NAME##*.} == "rar" ) ]]
		then
			return 1
		else
			return 0
		fi
			;;
	esac
}
SET_TEMP_FILE_LIST(){
	rm -rf ${TEMP_FILE_LIST} > /dev/null 2>&1
	touch ${TEMP_FILE_LIST} > /dev/null 2>&1
}
#-------------------------------------------------------------------
INPUT_DIR=${TEMP_UNZIP_PATH}
NUM_RUN=0
FILE_NUM=0
while true
do
	TEMP_FILE_LIST=${TEMP_PATH}/${RANDOM}.txt
	if [[ ! -f ${TEMP_FILE_LIST} ]]
	then
		break
	fi
done
DUMMY="."
TRY_PASS=""
#-------------------------------------------------------------------
while true
do
	let "NUM_RUN++"
	mkdir -p ${TEMP_UNZIP_PATH} > /dev/null 2>&1
	if [[ ! ${NUM_RUN} == 1 ]]
	then
		CHECKFILES_LIST=$(find ${DOWNFILE} -type f -name "*" )
		UNZIP_MULTI 256
		wait && SET_TEMP_FILE_LIST
		for i in ${CHECKFILES_LIST}
		do
			read -u4
			{
				CHECK_ARC $i
				[[ $? == 1 ]] && echo "$i" >> ${TEMP_FILE_LIST}
				echo >&4
			}&
		done
		wait && exec 4>&-
	else
		CHECK_ARC ${DOWNFILE}
		[[ $? == 1 ]] && echo "${DOWNFILE}" >> ${TEMP_FILE_LIST} && DOWNFILE=${DOWNFILE%%.*}_Dir
	fi
	for i in $(cat ${TEMP_FILE_LIST}| sort -n)
	do
		if [[ ${DUMMY%%.*} != ${i%%.*} ]]
		then
			FILE_LIST[${FILE_NUM}]=${i}
			DUMMY=${i}
			let "FILE_NUM++"
		fi
	done
#-----------------------------------------------------------------------
	if [[ ${#FILE_LIST[@]} > 0 ]]
	then
		UNZIP_MULTI ${UNZIP_THREAD} && wait
		for i in ${FILE_LIST[@]}
		do
			read -u4
			{
				while true
				do
					OUTPUT=$(7z t -y -r -bsp0 -bso0 -bse1 -aot -p"BADPASSWD" ${i})
					if [[ ! ${OUTPUT} =~ "Missing volume" ]] && [[ ! ${OUTPUT} =~ "Unexpected end of archive" ]]
					then
						break
					else
						sleep 30s
					fi
				done
				while true
				do
					if [[ $(find /datasets/ -type f -name $(echo ${i%%.*} | grep -oE "[^/]+$")*.aria2) == "" ]]
					then
						break
					else
						sleep 30s
					fi
				done
				for TRY_PASS in ${PASSWD[@]}
				do
					7z x -y -r -bsp1 -bso0 -bse0 -aot -p${TRY_PASS} -o${TEMP_UNZIP_PATH}$(echo -ne ${i//${TEMP_UNZIP_PATH}/} | grep -oE "[^\.]+"|head -1)_Dir ${i}
					if [[ ! $? == 2 ]] ; then break ; fi
				done
				rm -rf ${i}
				echo >&4
			}&
		done
		wait && exec 4>&-
	#Remove All Slice File
		for i in $(cat ${TEMP_FILE_LIST}) ; do rm -rf ${i%%\.*}.* ;done
		unset FILE_LIST
	else
		break
	fi
done
find ${TEMP_UNZIP_PATH} -type d -empty -exec rm -rf {} \;
[[ -d ${DOWNFILE} ]] && DSET=${DSET}${DOWNFILE##*/} && rclone mkdir ${DSET} --config "${RCLONE}"
rclone move ${DOWNFILE} ${DSET} -P -q --transfers=10 --cache-chunk-size 16M --no-traverse --create-empty-src-dirs --delete-empty-src-dirs --config "${RCLONE}"
wait && find ${TEMP_UNZIP_PATH} -type d -empty -exec rm -rf {} \;
#-------------------------------------------------------------------
IFS=$OLD_IFS