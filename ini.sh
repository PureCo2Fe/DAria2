[[ ! -d "/work" ]] && mkdir /work
rm -rf /datasets/* && rm -rf /work/frp
Vfrp="0.16.1" && wget -qO - https://github.com/fatedier/frp/releases/download/v${Vfrp}/frp_${Vfrp}_linux_amd64.tar.gz | tar -xzC /work && mv /work/frp_${Vfrp}_linux_amd64 /work/frp
#-------------------------------------------------------
cat > /work/frp/frpc.ini << EOF
[common]
server_addr = freenat.bid
server_port = 7000
privilege_token = frp888

[aria2tcp]
type = tcp
local_ip = 127.0.0.1
local_port = 6800
remote_port = 6800
#修改remote_port | 端口在：4000-50000 之间 | 建议改成难记的端口以免占用

[ssrtcp]
type = tcp
local_ip = 127.0.0.1
local_port = 10086
remote_port = 6801
#与Aria2不同

[rclonedaria2]
type = tcp
local_ip = 127.0.0.1
local_port = 5572
remote_port = 6802
EOF
#------------------------------------------------------
wget --no-check-certificate -qO /DAria2.zip https://github.com/e9965/DAria2/archive/main.zip && unzip -qq /DAria2.zip -d / && mv /DAria2-main /datasets && chmod +rwx /datasets/aria2.sh && chmod +rwx /datasets/sh.sh && rm -rf /DAria2.zip
sudo bash /datasets/aria2.sh e9965
cp -rf /datasets/conf/rclone.conf $HOME/.config/rclone/rclone.conf
ln -s /work/frp/frpc /bin/frpc
frpc -c /work/frp/frpc.ini & stress-ng -c 1 -l 1 -t 180d & rclone rcd --rc-web-gui --rc-web-gui-no-open-browser --rc-user gui --rc-pass e9965
