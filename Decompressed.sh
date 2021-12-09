#!/bin/bash
#-----------------------------------------------------------------------
#<程序運行-准备环境参数>
OLD_IFS=$IFS
IFS=$(echo -ne "\n\b")
export INPUT_DIR=/content/drive/MyDrive/Compressed
export SHELL_BOX_PATH=/content
export TEMP_UNZIP_PATH=${SHELL_BOX_PATH}/unzip/
export OUTPUT_PATH=/content/drive/MyDrive/Decompressed/
export yellow='\e[33m'
export blue='\e[34m'
export green='\e[92m'
export red='\e[91m'
export plain='\e[39m'
export UNZIP_THREAD=5
#-------------------------------------------------------------------------
#<程序基本運行函數>
function main(){
    init
    TRANSFER_COMPRESSED_FILE
    if [[ $(FILE_EXIST) == 1 ]]
    then
        UNZIP_FILE
        TRANSFER_DECOMPRESSED_FILE
        write $green "已完成传输"
    else
        write $red "未找到文件"
    fi
    CLEAN_TEMP
}

function CLEAN_TEMP(){
    rm -rf unzip_file_list.tmp
}

function REMOVE_SRC_FILE(){
    for i in $(cat unzip_file_list.tmp)
    do
        rm -rf ${TEMP_UNZIP_PATH}${i}
    done
}

function TRANSFER_DECOMPRESSED_FILE(){
    REMOVE_SRC_FILE
    INI_MKDIR ${OUTPUT_PATH}
    UNZIP_MULTI 5 && wait
    for i in $(find ${TEMP_UNZIP_PATH} -maxdepth 1 | sed "1d")
    do
        read -u4
        {
            write $red "正在传回【${i##*\/}】"
            mv ${i} ${OUTPUT_PATH}
            write $green "完成传回【${i##*\/}】"
            echo >&4
        }&
    done
    wait && exec 4>&-
}

function init(){
    write $yellow "正在准备环境参数"
    APT_UPDATE > /dev/null 2>&1
    INI_MKDIR ${TEMP_UNZIP_PATH}
    >& unzip_file_list.tmp
#The <unzip_file_list.tmp> is for recording the src. file name and removing them after the task is completed 
}

function UNZIP_FILE(){
    UNZIP_MULTI 5 && wait
	for i in $(find ${TEMP_UNZIP_PATH} | grep -iE "*.zip(.)+|*.7z|*.rar(.)+" | grep -vE "\.part[2-9]|[0-9].\.rar$" )
	do
		read -u4
		{
			write $red "正在解压压缩包【${i##*\/}】"
			7z x -y -r -bsp0 -bso0 -bse0 -aot -o${TEMP_UNZIP_PATH} ${i}
			rm -rf ${i}
			echo >&4
		}&
	done
	wait && exec 4>&-
}

function FILE_EXIST(){
#The Function return <1> whenever the INPUT_DIR has the file to be decompressed
#The Function return <0> whenever the INPUT_DIR doesn't have the file to be decompressed
    [[ $(ls ${TEMP_UNZIP_PATH}) == "" ]] && echo 1 || echo 0
}

function INI_MKDIR(){
	if [[ ! -d $1 ]] ; then	mkdir -p $1 ; fi
}
function write(){
	echo -e "${1}${2}${plain}"
}
function APT_UPDATE(){
#Add APT Src and Install 7z
		touch /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" > /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list.d/aliyun.list
		sudo apt-get update -y
		apt-get install --ignore-missing -y p7zip-full p7zip-rar -y
}

function UNZIP_MULTI(){
	temp_fifo="/tmp/$$.fifo"
	mkfifo ${temp_fifo}
	exec 4<>${temp_fifo}
	rm -f ${temp_fifo}
	for ((i=0;i<${1};i++))
	do
    	echo >&4
    done
}

function TRANSFER_COMPRESSED_FILE(){
#<程序運行-转移压缩包>
    UNZIP_MULTI 3 && wait
    for i in $(ls ${INPUT_DIR})
    do
    read -u4
    {
        echo "${i}" >> unzip_file_list.tmp
        write $blue "正在移动【${i}】"
        mv ${INPUT_DIR}/${i} ${TEMP_UNZIP_PATH} 
        write $green "移动压缩包【${i}】完成"
        echo >&4
    }&
    done
    wait && exec 4>&-
}
main
IFS=$OLD_IFS
exit 0
