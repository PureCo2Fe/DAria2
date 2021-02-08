DOWNFILE="/datasets/temp/unzip/星奈奈 2系列10套.part1.rar"
SLICE_CHECK(){
	if [[ -n $(echo ${DOWNFILE} | grep -oE "\.part[[:digit:]]+\.rar" | grep -vE "\.part1\.rar") ]] || [[ -n $(echo ${DOWNFILE} | grep -oE "\.z[[:digit:]]+") ]] || [[ -n $(echo ${DOWNFILE} | grep -oE "\.7z\.[[:digit:]]+" | grep -Ev "\.7z\.001") ]]
	then
		return 0
	else
		return 2
	fi
}
SLICE_CHECK && exit 0
echo Happy