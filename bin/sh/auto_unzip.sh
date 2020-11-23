#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#-------------------------------------------------------------------
DRAWLINE(){
	echo -e "${yellow}================================================================================${plain}"
}
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
	checkarc=$(file -b ${1}) && checkarc=${checkarc%%\ *}
	case ${checkarc} in
		RAR|rar|Rar|7-zip|7-Zip|7-Z|7-z|7z|7Z|7-ZIP|Zip|ZIP)
		return 1
			;;
		*)
		return 0
			;;
	esac
}
SET_TEMP_FILE_LIST(){
	rm -rf ${TEMP_FILE_LIST} > /dev/null 2>&1
	touch ${TEMP_FILE_LIST} > /dev/null 2>&1
}
DEL_BLANK_FOLDER(){
	find ${TEMP_PATH} -type d -empty -delete
}
#-------------------------------------------------------------------
INPUT_DIR=${TEMP_UNZIP_PATH}
NUM_RUN=0
FILE_NUM=0
TEMP_FILE_LIST=${TEMP_PATH}/list.txt
DUMMY="."
TRY_PASS=""
SET_SUCC_FILE_LIST && DEL_BLANK_FOLDER
#-------------------------------------------------------------------
while true
do
	let "NUM_RUN++"
	DRAWLINE
	mkdir -p ${TEMP_UNZIP_PATH} > /dev/null 2>&1
	CHECKFILES_LIST=$(find ${INPUT_DIR} -type f -name "*" )
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
	for i in $(cat ${TEMP_FILE_LIST}| sort -n)
	do
		if [[ ${DUMMY%%.*} != ${i%%.*} ]]
		then
			CONC_PATH ${i} 0
			FILE_LIST[${FILE_NUM}]=${a}
			DUMMY=${i}
			let "FILE_NUM++"
		fi
	done
	if [[ ${#FILE_LIST[@]} > 0 ]]
	then
		UNZIP_MULTI ${UNZIP_THREAD} && wait
		for i in ${FILE_LIST[@]}
		do
			read -u4
			{
				for TRY_PASS in ${PASSWD[@]}
				do
					7z x -y -r -bsp1 -bso0 -bse0 -aot -p${TRY_PASS} -o${TEMP_UNZIP_PATH}${i##*\/} ${i}
					[[ $? != 2 ]] && break
				done
				echo >&4
			}&
		done
		wait && exec 4>&-
	#Remove All Succ File
		for i in $(cat ${TEMP_FILE_LIST})
		do
			rm -f ${i}
		done
		unset FILE_LIST
	else
		break
	fi
done
DEL_BLANK_FOLDER > /dev/null 2>&1
rclone move ${TEMP_UNZIP_PATH} OneDrive:/ -v --transfers=${MAXPARALLEL} --cache-chunk-size 16M --no-traverse --config "${RCLONE}"
wait && DEL_BLANK_FOLDER > /dev/null 2>&1
#-------------------------------------------------------------------
IFS=$OLD_IFS