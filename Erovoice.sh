#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -ne "\n\b")
#-------------------------------------------------------------------------
#<程序基本運行函數>
INI_MKDIR(){
	if [[ ! -d $1 ]] ; then	mkdir -p $1 ; fi
}
write(){
	echo -e "${1}${2}${plain}"
}
SET_BASIC_ENV_VAR(){
	export yellow='\033[43;37m'
	export blue='\033[44;37m'
	export green='\033[42;37m'
	export red='\033[41;37m'
	export plain='\033[0m'
	export UNZIP_THREAD=5
	export TEMP_UNZIP_PATH=${SHELL_BOX_PATH}/unzip/ && INI_MKDIR ${TEMP_UNZIP_PATH}
	export INPUT_DIR=${SHELL_BOX_PATH}/drive/MyDrive/Sharer.pw
	export RCLONE="${SHELL_BOX_PATH}/rclone.conf"
	cat > $RCLONE <<EOF
[Onedrive]
type = onedrive
client_id = e6adedec-2a30-40e0-9736-493192820a4a
client_secret = F.pUadXlmtzp-2M~b-8Ifogy5cLa-5vp~N
token = {"access_token":"eyJ0eXAiOiJKV1QiLCJub25jZSI6ImZNSndkdlQ1RDE4bnZ3dkpPTlJMYjJvLXFwZEhnX3JYU2gzNTRYd29UU0EiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lZjYzN2EzNS1kY2E0LTRkZTMtOTE4OC0zODAzMGQ3NWZjMzIvIiwiaWF0IjoxNjExNDk2MDYzLCJuYmYiOjE2MTE0OTYwNjMsImV4cCI6MTYxMTQ5OTk2MywiYWNjdCI6MCwiYWNyIjoiMSIsImFjcnMiOlsidXJuOnVzZXI6cmVnaXN0ZXJzZWN1cml0eWluZm8iLCJ1cm46bWljcm9zb2Z0OnJlcTEiLCJ1cm46bWljcm9zb2Z0OnJlcTIiLCJ1cm46bWljcm9zb2Z0OnJlcTMiLCJjMSIsImMyIiwiYzMiLCJjNCIsImM1IiwiYzYiLCJjNyIsImM4IiwiYzkiLCJjMTAiLCJjMTEiLCJjMTIiLCJjMTMiLCJjMTQiLCJjMTUiLCJjMTYiLCJjMTciLCJjMTgiLCJjMTkiLCJjMjAiLCJjMjEiLCJjMjIiLCJjMjMiLCJjMjQiLCJjMjUiXSwiYWlvIjoiRTJKZ1lQQzFZOVFKbnRxeHFiZjVFOU5NeTlmQzk4bzlTamJ1cVdzL21jckVmeVZ1OTJVQSIsImFtciI6WyJwd2QiXSwiYXBwX2Rpc3BsYXluYW1lIjoiU2hlbGxEcml2ZSIsImFwcGlkIjoiZTZhZGVkZWMtMmEzMC00MGUwLTk3MzYtNDkzMTkyODIwYTRhIiwiYXBwaWRhY3IiOiIxIiwiZmFtaWx5X25hbWUiOiJXb25nIiwiZ2l2ZW5fbmFtZSI6Ikt3b2sgWWluIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiMjAzLjIxOC4xODIuMzciLCJuYW1lIjoiS3dvayBZaW4gV29uZyIsIm9pZCI6ImJmNzI2ZjRjLWJlNjgtNGVlYi1iYTdmLWM5OGQwNzQzNzk2YiIsInBsYXRmIjoiMyIsInB1aWQiOiIxMDAzMjAwMEI3OERBNjMyIiwicmgiOiIwLkFBQUFOWHBqNzZUYzQwMlJpRGdERFhYOE11enRyZVl3S3VCQWx6WkpNWktDQ2twS0FNRS4iLCJzY3AiOiJGaWxlcy5SZWFkIEZpbGVzLlJlYWQuQWxsIEZpbGVzLlJlYWRXcml0ZSBGaWxlcy5SZWFkV3JpdGUuQWxsIFNpdGVzLlJlYWQuQWxsIFVzZXIuUmVhZCBwcm9maWxlIG9wZW5pZCBlbWFpbCIsInN1YiI6Ik00NzYxNlh2dldabUkxazBmaWp6ZHhNOWZ4bUhjWHozU3R4UElmSGg1a3MiLCJ0ZW5hbnRfcmVnaW9uX3Njb3BlIjoiQVMiLCJ0aWQiOiJlZjYzN2EzNS1kY2E0LTRkZTMtOTE4OC0zODAzMGQ3NWZjMzIiLCJ1bmlxdWVfbmFtZSI6Iktlbm55ZHJpdmVAbGl2ZXN0dWR5Lm9ubWljcm9zb2Z0LmNvbSIsInVwbiI6Iktlbm55ZHJpdmVAbGl2ZXN0dWR5Lm9ubWljcm9zb2Z0LmNvbSIsInV0aSI6InZXd0NrNFRWQzA2dFVqQTVmSlVqQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfc3QiOnsic3ViIjoiZEtGTm45YzhQLXZtTUNzOVg3NFplaEU3M2doUFQzVEg5djJEYU43ZjhLOCJ9LCJ4bXNfdGNkdCI6MTU4NzgxNTUzM30.PjVuMdZ8ZIAl3cx1CDDxMX1OJVO5sumqCXYZgNyqOl8e1omFyyRlmFpEeUnNk8yLsEWEAATVOn9TXd7c3x5XubBWsuoPm8y7bWqtbt5VN9CTEP8xWoSam7UCIJu1fkt8NJylCSUK9dD2Gmup8VMb0qIzt0emEYgbDMPtvTzOT4CTQpozbnk0XHtdonK8obJdKiRNR9yUT_LVe6ZzAUWYRSNoj3mS6BJYW1AOzZU0AW0019PVYjhGb6JdOX0GWHF-dIsm_81OFBwiPxGF7XETAP05RST8nV7pnHI-YTokWlVmUvRyqyo01DOP4IhuNxIk-oGYP_IFN50m1UVPG-06Tw","token_type":"Bearer","refresh_token":"0.AAAANXpj76Tc402RiDgDDXX8MuztreYwKuBAlzZJMZKCCkpKAME.AgABAAAAAABeStGSRwwnTq2vHplZ9KL4AQDs_wMA9P8fST0toHscsP3tpRzntQydqobz2baRhtr2ST2YnbMAeioyu3MFJskd7jVKW-6xnLPcV3P_HesHxlsThfzYzc2xkw4lKt6A_XFpEgvLcVNeYij99MVzpZW2v2-LSMJPe_I0yf4Xe-hFB0m53g4guFvEmeUXgVN5ypat1w8djrw31L4r_W5VleX-Ymm_KAkEoRA2Mdgsp1fFQha3SIq5vwxgYbJMMlMLHuMzyUGrmDzJB2qSH2u1Jmm0QUcHtP1Y-4EXlVIPxz0N54gQeD_M3MuleYzNKNSyNKfqfZI7xarlAMixRKXmy-0hrN1EO2XIYdrQ2qiVZ3OOmlIYFbjF6qcGVtLiaWjBNzpMGuYC36HlHHB0iQKzzqeVNbNBnojlMMg9oNN77MvrQoAVfrCxFnNiqIjKNT-vYauky1G_rF68nj4DxHMTtUCn4MruNxALHJMaa-AohNTqJudBpED19N8G2hBkGtmFTD1-nDGLQ8_F-E-tdcd1qBoi9epIY7cMwmyqVINUXN68iynNURkZ5-JFDfW_4l3IwPCZIvSJnVeTDCp6S6pufx8_TnRLnzLT1ZOTctFHQO7B2DX_5IUbeWLb767tQkZ-UHM78whTmU_UCKZrvFqlziE8zMX9agYFrgZm0-iTq5MU4p6he59nJjHadftO_FAX0lfGt_m8YgX4brIWBWwIxW3tJ7P_g6JiT-TaePOIIQvUbi8dwl259TunJsKfjrTR7dXNrT0cgBJmjxnzFTxsxesr8HPjER0RncKXwRgRqIH0yRsf1Pv0rvvAwvyBuLyX-Q-DPAU28Um_fBhTMKJPYRQmcnTX8JHiXaoRWLlwaZmHnvs6k1shLJ9o0oMJkRqN5APeNwS-s6C4NjGdf23ixZLgoFNK7HnuYmzQc42jF1x9tNPbWifwwYPMMtic9xwQ6ToFz4nOAiOcdw_EO3OWBiafYQE","expiry":"2021-01-24T22:52:43.0970467+08:00"}
drive_id = b!Eqi24yxqskerRNr1u_lOk00lazGaLd5PhaR2PCLAGBnPUNHHJwlBTZYrzougHOta
drive_type = business
[Google]
type = drive
client_id = 959968594915-nhjkq2o036uhpn371fsecdu5g5qe1man.apps.googleusercontent.com
client_secret = 5PSKfHPsuDatfNMkb-rmxHdz
scope = drive
root_folder_id = 1a024AbVvZ19ua-1cqiQ-e5b1xpYqLP2H
token = {"access_token":"ya29.a0AfH6SMAKQECT3hk8-pyTOOBDE69x1R4IJyj9m94mf06hBB2_GID1k7NdRFUUDd8GP-8ENpuQaNlYw-1uFTnnR1fpZo7bbli7xbOQWqct2i3xouI5ZcQblrEqko2fYNycaCzJf-xCmQZLcqFVBp6OVfLvnu-g","token_type":"Bearer","refresh_token":"1//05fLupGIHfwY9CgYIARAAGAUSNwF-L9Ir_YF4v5dzPuKWJPO6P0TAqIdEqkD47bCZtz43qLHaEZxpR6kXuozNZtICORwwEIyCKPQ","expiry":"2021-04-07T11:52:43.953845811Z"}
EOF
}
INSTALL_RCLONE(){
	if [[ $(whereis rclone|cut -d":" -f2) == "" ]]
	then
		curl https://rclone.org/install.sh | sudo bash
	fi
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
APTUPDATE(){
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
#-----------------------------------------------------------------------
#<程序運行-准备环境参数>
write $yellow "正在准备环境参数"
SHELL_BOX_PATH=$(readlink -f ${0})
export SHELL_BOX_PATH=${SHELL_BOX_PATH%\/*}
SET_BASIC_ENV_VAR
INSTALL_RCLONE > /dev/null 2>&1
APTUPDATE > /dev/null 2>&1
#-----------------------------------------------------------------------
#<程序運行-转移压缩包>
write $blue "正在转移压缩包"
for i in $(ls ${INPUT_DIR})
do
	write $blue "正在移动【${i}】"
	mv ${INPUT_DIR}/${i} ${TEMP_UNZIP_PATH} 
	write $green "移动压缩包【${i}】完成"
done
#-----------------------------------------------------------------------
#<程序运行-解压压缩包>
if [[ $(find ${TEMP_UNZIP_PATH} -type f -name "*.rar"|wc -l) > 0 ]]
then
	UNZIP_MULTI 5 && wait
	for i in $(find ${TEMP_UNZIP_PATH} -type f -name "*.rar")
	do
		read -u4
		{
			write $red "正在解压压缩包【${i##*\/}】"
			7z x -y -r -bsp1 -bso0 -bse0 -aot -o${TEMP_UNZIP_PATH} ${i}
			rm -rf ${i}
			echo >&4
		}&
	done
	wait && exec 4>&-
	#-----------------------------------------------------------------------
	#<程序运行-简化压缩包>
	write $yellow "正在简化Erovoice压缩包结构"
	for i in $(find ${TEMP_UNZIP_PATH} -maxdepth 2 -type d | grep -E "RJ[[:digit:]]+-EroVoice.us")
	do
		{
			mv ${i}/* ${i%\/*}
			rm -rf ${i}
		}&
	done
	wait
	find ${TEMP_UNZIP_PATH} -type f -name "Information.txt" -empty -exec rm -rf {} \;
	#-----------------------------------------------------------------------
	#<程序运行-传回文档>
	UNZIP_MULTI 5 && wait
	for i in $(find ${TEMP_UNZIP_PATH} -maxdepth 1 -type d | sed "1d")
	do
		read -u4
		{
			write $red "正在传回【${i##*\/}】"
			rclone move ${i} Onedrive:/${i##*\/} -P -q --transfers=20 --cache-chunk-size 32M --ignore-errors --no-traverse --create-empty-src-dirs --delete-empty-src-dirs --config "${RCLONE}" > /dev/null 2>&1
			write $green "完成传回【${i##*\/}】"
			echo >&4
		}&
	done
	wait && exec 4>&-
	#-----------------------------------------------------------------------
fi
write $green "已完成传输"
IFS=$OLD_IFS
exit 0
