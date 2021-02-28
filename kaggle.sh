[[ ! -d "/work" ]] && mkdir /work
rm -rf /datasets/* && rm -rf /work/frp
wget -qO - https://git.io/dria2ini | bash & wget -qO - https://git.io/dria2frp | bash
