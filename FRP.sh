Vfrp="0.16.1" && wget -qO frp.tar.gz https://github.com/fatedier/frp/releases/download/v${Vfrp}/frp_${Vfrp}_linux_amd64.tar.gz
tar -xzvf frp.tar.gz && mv frp_${Vfrp}_linux_amd64 frp
#-------------------------------------------------------
cat > ./frp/frpc.ini << EOF
[common]
server_addr = freenat.bid
server_port = 7000
privilege_token = frp888

[aria2tcp]
type = tcp
local_ip = 127.0.0.1
local_port = 6800
remote_port = 6800

[ssrtcp]
type = tcp
local_ip = 127.0.0.1
local_port = 10086
remote_port = 6801

[daria2_ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6822

[https_gd]
type = https
local_ip = 127.0.0.1
local_port = 5212
use_compression = true
use_encryption = true
custom_domains = gd.freenat.bid
EOF
#------------------------------------------------------
wget --no-check-certificate -qO DAria2.zip https://github.com/e9965/DAria2/blob/main/DAria2.zip?raw=true && tar -vxzf DAria2.zip && chmod +rwx aria2.sh && chmod +rwx sh.sh && rm -rf DAria2.zip
sudo bash aria2.sh e9965 && cd frp
./frpc -c /work/frp/frpc.ini & stress-ng -c 1 -l 1 -t 180d
