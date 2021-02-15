wget --no-check-certificate -qO /DAria2.zip https://github.com/e9965/DAria2/archive/main.zip && unzip -qq /DAria2.zip -d / && mv /DAria2-main /datasets && chmod +rwx /datasets/aria2.sh && chmod +rwx /datasets/sh.sh && rm -rf /DAria2.zip
sudo bash /datasets/aria2.sh e9965
mkdir -p $HOME/.config/rclone/
cp -rf /datasets/conf/rclone.conf $HOME/.config/rclone/rclone.conf
while true
do
if [[ $(ps aux | grep -E "teleconsole" | grep -vE "grep") == "" ]]
then
    rm -rf /kaggle/working/*
    teleconsole > /datasets/console.conf 2>&1
    sleep 60s
    ID=$(grep -E "Your Teleconsole ID: " /datasets/console.conf | cut -d" " -f4)
    if [[ ! ${ID} == "" ]]
    then
        touch /kaggle/working/${ID}.txt
    fi
fi
sleep 30s
done
