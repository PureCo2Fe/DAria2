#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
DSET="OneDrive:/"
MOVIEDIR="/datasets/temp"
export ORG_URL=$(cat /root/.aria2c/aria2.session|grep "${DOWNFILE##*\/}"|grep "http"|tail -1|sed "s/[ \t]*$//g")
[[ ! -d ${MOVIEDIR}/movie ]] && mkdir -p ${MOVIEDIR}/movie
#-------------------------------------------------------------------
cd ${MOVIEDIR} && echo "${ORG_URL}\""
while true
do
    VNAME=$(openssl rand -hex 5)
    [[ ! -f ${MOVIEDIR}/movie/${VNAME}.mp4 ]] && break
done
m3u8d -u="${ORG_URL}" -o="${VNAME}" -n=32 -ht=apiv2
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
