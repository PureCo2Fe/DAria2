#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
DSET="OneDrive:/"
MOVIEDIR="/datasets/temp"
export ORG_URL=$(cat /root/.aria2c/aria2.session|grep "${DOWNFILE##*\/}"|grep "http"|tail -1|sed "s/[ \t]*$//g")
[[ ! -d ${MOVIEDIR}/movie ]] && mkdir -p ${MOVIEDIR}/movie
#-------------------------------------------------------------------
cd ${MOVIEDIR}/movie && echo "${ORG_URL}\""
while true
do
    VNAME=$(openssl rand -hex 5)
    [[ ! -f ${MOVIEDIR}/movie/${VNAME}.mp4 ]] && break
done
/home/jovyan/.local/bin/downloadm3u8 -o ${MOVIEDIR}/movie/${VNAME}.mp4 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36 Edg/87.0.664.66" -c 32 "${ORG_URL}"
if [[ $? == 0 ]]
then
    rclone move ${MOVIEDIR}/movie/${VNAME}.mp4 ${DSET} -v --transfers=5 --cache-chunk-size 32M --no-traverse --create-empty-src-dirs --delete-empty-src-dirs --config "${RCLONE}"
    wait && find ${TEMP_UNZIP_PATH} -type d -empty -exec rm -rf {} \;
else
    rm -rf ${MOVIEDIR}/movie/${VNAME}*
fi
rm -rf ${DOWNFILE}
#-------------------------------------------------------------------
IFS=$OLD_IFS
