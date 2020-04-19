#!/bin/bash
echo $ID
# if ID is set then use it to clone the user SID
[ -z "$ID" ] || /bin/bash /build/id-clone $ID  
rm -rf /home/zues
tar -C /home/ -xvf /build/zues.tar 
chown -R $SID /home/zues

[ -z "$ID" ] \
&& [ "$SID" != "zues" ] \
&& [ $(cat /etc/passwd | grep zues | wc -l) == 1 ] \
&& echo "$SID is not a user...creating $SID" \
&& mkdir -p /home/$SID \
&& usermod -d /home/$SID zues \
&& usermod -l $SID zues \
&& usermod -aG wheel $SID \
&& chown -R $SID /home/zues \
&& ln -s /home/zues /home/$SID

[ -z "$ID" ] \
&& [ "$(id $SID -u)" != "$UID" ] \
&& echo "Changing UID of $SID" \
&& usermod -u $UID $SID \
&& chown -R $SID /home/zues

[ -z "$ID" ] \
&& [ "$(id $SID -g)" != "$GID" ] \
&& echo "Changing Default GID of $SID" \
&& OG=$(id $SID -g -n) \
&& groupmod -g $GID $OG \
&& chown -R $SID /home/zues 

[ "$(cat ~/.bashrc | grep XDG_CONFIG_HOME | wc -l)" -lt "1" ] \
    && echo "XDG_CONFIG_HOME=/home/zues/.config" >> /home/zues/.bashrc \
    && echo "alias pycharm='/home/zues/.local/share/umake/ide/pycharm/bin/pycharm.sh'" >> /home/zues/.bashrc

echo "Default JupyterLab Password is zues" 
echo 'root:zues' | chpasswd 

cd /home/$SID 


# launch jupyter lab OR run command passed in with $@
if [ $# -eq 0 ]; then
    su $SID -c jupyter lab --ip 0.0.0.0 
else
    su $SID -c $@
fi
