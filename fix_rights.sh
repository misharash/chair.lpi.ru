#!/usr/local/bin/bash
DIR=/home/edigaryev/chair/new/chair.lpi.ru
chown -R edigaryev:chair $DIR
find $DIR -type d -print0 | xargs -0 chmod 777
find $DIR -type f -print0 | xargs -0 chmod 666
chmod +x $DIR/fix_rights.sh
#chmod +x $DIR/update.py
