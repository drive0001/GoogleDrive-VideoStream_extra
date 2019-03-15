#
# docker_backup.sh current_date_YYYYMMDD location_of_scripts port access_token docker_instance_name
#
date=`date --reference=last.backup.done`
sudo touch last.backup.start
tar -N "$date" -zcf cache.$1.tgz cache
tar -N "$date" -zcf config.$1.tgz config
tar -N "$date" -zcf localization.$1.tgz localization
tar -N "$date" -zcf metadata.$1.tgz metadata
tar -N "$date" -zcf plugins.$1.tgz plugins
tar -N "$date" -zcf root.$1.tgz root
perl $2/stop_emby.pl -p $3 -a $4
sleep 5
sudo docker stop $5
sleep 5
tar -zcf "data.$1.tgz" "data"
sudo docker start $5
mv last.backup.start last.backup.done