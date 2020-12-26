#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
DSET="OneDrive:/"
MOVIEDIR="/datasets/temp/movie"
rm -rf ${DOWNFILE}
[[ ! -d ${MOVIEDIR} ]] && mkdir -p ${MOVIEDIR}
#-------------------------------------------------------------------
cd ${MOVIEDIR}
echo "${ORG_URL}\""
while true
do
    VNAME=$(openssl rand -hex 5)
    [[ ! -f ${MOVIEDIR}/${VNAME}.mp4 ]] && break
done
ffmpeg -i "${ORG_URL}" -bsf:a aac_adtstoasc -vcodec copy -c copy ${VNAME}.mp4
if [[ $? == 0 ]]
then
    rclone move ${MOVIEDIR}/${VNAME}.mp4 ${DSET} -v --transfers=5 --cache-chunk-size 32M --no-traverse --create-empty-src-dirs --delete-empty-src-dirs --config "${RCLONE}"
    wait && find ${TEMP_UNZIP_PATH} -type d -empty -exec rm -rf {} \;
else
    rm -rf ${VNAME}*
fi
#-------------------------------------------------------------------
IFS=$OLD_IFS
