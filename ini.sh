wget --no-check-certificate -qO /DAria2.zip https://github.com/e9965/DAria2/archive/main.zip && unzip -qq /DAria2.zip -d / && mv /DAria2-main /datasets && chmod +rwx /datasets/aria2.sh && chmod +rwx /datasets/sh.sh && rm -rf /DAria2.zip
sudo bash /datasets/aria2.sh e9965
mkdir -p $HOME/.config/rclone/
cp -rf /datasets/conf/rclone.conf $HOME/.config/rclone/rclone.conf
rclone rcd --rc-web-gui --rc-web-gui-no-open-browser --rc-user gui --rc-pass e9965
touch /datasets/complete
