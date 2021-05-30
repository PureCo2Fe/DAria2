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
	export yellow='\e[33m'
	export blue='\e[34m'
	export green='\e[92m'
	export red='\e[91m'
	export plain='\e[39m'
	export UNZIP_THREAD=5
	export TEMP_UNZIP_PATH=${SHELL_BOX_PATH}/unzip/ && INI_MKDIR ${TEMP_UNZIP_PATH}
	export INPUT_DIR=${SHELL_BOX_PATH}/drive/MyDrive/Sharer.pw
	export RCLONE="${SHELL_BOX_PATH}/rclone.conf"
	cat > $RCLONE <<EOF
[Onedrive]
type = onedrive
client_id = e6adedec-2a30-40e0-9736-493192820a4a
client_secret = F.pUadXlmtzp-2M~b-8Ifogy5cLa-5vp~N
region = global
token = {"access_token":"eyJ0eXAiOiJKV1QiLCJub25jZSI6IjJaWGtmbldQWl95U1QyUGx3Zi05bWJTTFhZdVhQQzFuNXJ2VHF1TmJRZ0kiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9lZjYzN2EzNS1kY2E0LTRkZTMtOTE4OC0zODAzMGQ3NWZjMzIvIiwiaWF0IjoxNjE4MDY4NjIyLCJuYmYiOjE2MTgwNjg2MjIsImV4cCI6MTYxODA3MjUyMiwiYWNjdCI6MCwiYWNyIjoiMSIsImFjcnMiOlsidXJuOnVzZXI6cmVnaXN0ZXJzZWN1cml0eWluZm8iLCJ1cm46bWljcm9zb2Z0OnJlcTEiLCJ1cm46bWljcm9zb2Z0OnJlcTIiLCJ1cm46bWljcm9zb2Z0OnJlcTMiLCJjMSIsImMyIiwiYzMiLCJjNCIsImM1IiwiYzYiLCJjNyIsImM4IiwiYzkiLCJjMTAiLCJjMTEiLCJjMTIiLCJjMTMiLCJjMTQiLCJjMTUiLCJjMTYiLCJjMTciLCJjMTgiLCJjMTkiLCJjMjAiLCJjMjEiLCJjMjIiLCJjMjMiLCJjMjQiLCJjMjUiXSwiYWlvIjoiRTJaZ1lCQVJWSXljVzhWeTEzTG13WFNtbmNYWlhCWGZWZDl3Ukh2dStDOHR1dkxCMnFzQSIsImFtciI6WyJwd2QiXSwiYXBwX2Rpc3BsYXluYW1lIjoiU2hlbGxEcml2ZSIsImFwcGlkIjoiZTZhZGVkZWMtMmEzMC00MGUwLTk3MzYtNDkzMTkyODIwYTRhIiwiYXBwaWRhY3IiOiIxIiwiZmFtaWx5X25hbWUiOiJXb25nIiwiZ2l2ZW5fbmFtZSI6Ikt3b2sgWWluIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiMjAzLjIxOC4xODIuMTA2IiwibmFtZSI6Ikt3b2sgWWluIFdvbmciLCJvaWQiOiJiZjcyNmY0Yy1iZTY4LTRlZWItYmE3Zi1jOThkMDc0Mzc5NmIiLCJwbGF0ZiI6IjMiLCJwdWlkIjoiMTAwMzIwMDBCNzhEQTYzMiIsInJoIjoiMC5BVW9BTlhwajc2VGM0MDJSaURnRERYWDhNdXp0cmVZd0t1QkFselpKTVpLQ0NrcEtBTUUuIiwic2NwIjoiRmlsZXMuUmVhZCBGaWxlcy5SZWFkLkFsbCBGaWxlcy5SZWFkV3JpdGUgRmlsZXMuUmVhZFdyaXRlLkFsbCBTaXRlcy5SZWFkLkFsbCBVc2VyLlJlYWQgcHJvZmlsZSBvcGVuaWQgZW1haWwiLCJzaWduaW5fc3RhdGUiOlsia21zaSJdLCJzdWIiOiJNNDc2MTZYdnZXWm1JMWswZmlqemR4TTlmeG1IY1h6M1N0eFBJZkhoNWtzIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkFTIiwidGlkIjoiZWY2MzdhMzUtZGNhNC00ZGUzLTkxODgtMzgwMzBkNzVmYzMyIiwidW5pcXVlX25hbWUiOiJLZW5ueWRyaXZlQGxpdmVzdHVkeS5vbm1pY3Jvc29mdC5jb20iLCJ1cG4iOiJLZW5ueWRyaXZlQGxpdmVzdHVkeS5vbm1pY3Jvc29mdC5jb20iLCJ1dGkiOiJuQUh2ckwzNjZVV0U2am45cjZjVEFBIiwidmVyIjoiMS4wIiwid2lkcyI6WyI2MmU5MDM5NC02OWY1LTQyMzctOTE5MC0wMTIxNzcxNDVlMTAiLCJiNzlmYmY0ZC0zZWY5LTQ2ODktODE0My03NmIxOTRlODU1MDkiXSwieG1zX3N0Ijp7InN1YiI6ImRLRk5uOWM4UC12bU1DczlYNzRaZWhFNzNnaFBUM1RIOXYyRGFON2Y4SzgifSwieG1zX3RjZHQiOjE1ODc4MTU1MzN9.fFaqcqHeqdPhviF_nUZGr7FGAK57am3Vwnbv5Xzn2hbpqR1VBhprBbesaRV3M-WK4FKDjllRCEFVQ5f3JBLB-suTHTMqlUfg4S55ZUo_JesheWjt8JahYPjXSDq-gqCw1Zq-zxiiArBl5N3CLHSCGXP2pLIBoiDs9RySWBINXelsiA1XJCQJE_pzNeP6qFU_Wgu0yarbXXSe_-WaCP8vrURnEtp5V2_7RQ_pZY4A8C8JR1IzJfFM-qa4qDsvwOz6HEPSierGaLDuFb3fT7Hel_zst-LemS3wXjEB8lwU05hH9I1APff7Y1Pzt-Nf4AG0xnH0TlCzi0ZC-Hz6iHKcAQ","token_type":"Bearer","refresh_token":"0.AUoANXpj76Tc402RiDgDDXX8MuztreYwKuBAlzZJMZKCCkpKAME.AgABAAAAAAD--DLA3VO7QrddgJg7WevrAgDs_wQA9P-8DpAR4Zurdilh7O2SirAdf8tHxx9k1j1ofbjYObItGiBBHM-3uwoI9j5Utf-aGqrKoac3DH7p5vSA3zRllcIbn1--vhGk4ytKNfxgoudBFrzPGD7BQiCefMdQ0wc7Bwf1Nk_c55fb5bC7KzGNbcNzJGWrT93KCyNsR2ZFvBRnjOsIczyNfDyqdwZepiJlQPyqaKybxVtNatIZqsjuNXp1_oWB_465FSaH97KxTmtKJOEmh5TA8zL1hSgSdHMoFpIqdjMWj2Oh4CytBI7SfgjrbcRdFGq4DAyRbDSE3OYjXDtdLozliY-4Kkp8lyPZB7YdlZgUuv1wdyVZ1pKhLteHqqii_ZNBbmjsKjw2wG-JJlkKXon4WedzK4hcd4OYgOzqthbcUx28HS_yRvnjez9onPGI8uV5lKulcZV8L9yJ9k8WZRLFEl8q5BRPEj4Kq9dfs5M2nGvkEZeyqu4ZqzS5vR9gpsAotrokxmZ91g9MFDl1oo1zwQFf9xrChrP9E6HOnk6f26IuSR70P-zQdhEWQ0-1Il7kcWpn_qQA7iOh2YfWcLPPLO6ZQGX4A7Vwnu2epUPS98f4jueBhZJeps9efyhSmYCAKASvn7b3OE8N2qb3q6KTsfGVHc4b-d7mXJeuVuuXFC2aAlTC1CGLGsprOvpqiLeGkvnamK_-V-wU7Tq5byZY-wGAgz3WRx_TmrhC4NEF9W10uDzmrryZLZ9CplF9JzGSvL_BHvcTvQP5-pS-KuwNOL3UOnyFBrIzH9UaCMWoVgRe6rQxDWzkO-MYwSXMnj-lWrw6HoWxNixr2yYdTHXZ9y7Im7VvEdEc-tDzijoq8MuNPR1OF3mK0NRpe-uF-ZGWaCjKJCi32gTB4YBcmFSl2SH1nasm-bB0z9L9HM8qGdz1o7ch-DXb678TZb-_XKEXDjhuwR9wKzCkwzz99YcgftzXDGrjIcla-L8W3ss","expiry":"2021-04-11T00:35:21.7784769+08:00"}
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
#-----------------------------------------------------------------------
#<程序運行-准备环境参数>
SHELL_BOX_PATH=$(readlink -f ${0})
export SHELL_BOX_PATH=${SHELL_BOX_PATH%\/*}
SET_BASIC_ENV_VAR
write $yellow "正在准备环境参数"
INSTALL_RCLONE > /dev/null 2>&1
#-----------------------------------------------------------------------
#<程序運行-转移压缩包>
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
			7z x -y -r -bsp0 -bso0 -bse0 -aot -o${TEMP_UNZIP_PATH} ${i}
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
	find ${TEMP_UNZIP_PATH} -type f -name "Information.txt" -exec rm -rf {} \;
	#-----------------------------------------------------------------------
	#<程序运行-传回文档>
	UNZIP_MULTI 5 && wait
	for i in $(find ${TEMP_UNZIP_PATH} -maxdepth 1 -type d | sed "1d")
	do
		read -u4
		{
			write $red "正在传回【${i##*\/}】"
			rclone copy ${i} Onedrive:/${i##*\/} -q --transfers=20 --cache-chunk-size 32M --ignore-errors --no-traverse --create-empty-src-dirs --delete-empty-src-dirs --config "${RCLONE}" > /dev/null 2>&1
			mv ${i} /content/drive/MyDrive/Temporary/${i##*\/}
			write $green "完成传回【${i##*\/}】"
			echo >&4
		}&
	done
	wait && exec 4>&-
	#-----------------------------------------------------------------------
	write $green "已完成传输"
else
	write $red "未找到文件"
fi
IFS=$OLD_IFS
exit 0
