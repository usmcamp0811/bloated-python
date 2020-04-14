#!/bin/bash


[ "$SID" != "zues" ] \
&& [ $(cat /etc/passwd | grep zues | wc -l) == 1 ] \
&& echo "$SID is not a user...creating $SID" \
&& mkdir -p /home/$SID \
&& usermod -d /home/$SID zues \
&& usermod -l $SID zues \
&& usermod -aG wheel $SID \
&& chown -R $SID /home/zues \
&& ln -s /home/zues /home/$SID


[ "$(id $SID -u)" != "$UID" ] \
&& echo "Changing UID of $SID" \
&& usermod -u $UID $SID \
&& chown -R $SID /home/zues

[ "$(id $SID -g)" != "$GID" ] \
&& echo "Changing Default GID of $SID" \
&& OG=$(id $SID -g -n) \
&& groupmod -g $GID $OG \
&& chown -R $SID /home/zues

# if ID is set then use it to clone the user SID
[ -z "$ID" ] || ( /bin/bash /id-clone && /bin/bash /clone-user )

# change user 
su $SID
# go home
cd /home/$SID
echo "Default JupyterLab Password is zues"
su $SID -c 'jupyter lab --ip 0.0.0.0'
