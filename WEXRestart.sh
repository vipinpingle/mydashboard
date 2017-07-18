#!/bin/sh
###edit the following
host=`hostname -f`
engineservice=/opt/ibm/WEX/Engine/java/jre/bin/java
appbuilderservice=AppBuilder
zookeeperservice=ZooKeeper
###stop editing
if (( $(ps -ef | grep -v grep | grep $appbuilderservice | wc -l) > 0 ))
then
echo "$appbuilderservice is running"
#/opt/ibm/WEX/AppBuilder/wlp/bin/server stop AppBuilder
else
echo "$appbuilderservice is already stopped"
fi
#sleep 1m
if (( $(ps -ef | grep -v grep | grep $zookeeperservice | wc -l) > 0 ))
then
echo "$zookeeperservice is running"
#/opt/ibm/WEX/ZooKeeper/zookeeper/bin/zkServer.sh stop
else
echo "$zookeeperservice is already stopped"
fi
#sleep 1m
if (( $(ps -ef | grep -v grep | grep $engineservice | wc -l) > 0 ))
then
echo "$engineservice is running"
#/opt/ibm/WEX/Engine/bin/engine-shutdown
else
echo "$engineservice is already stopped"
fi
sleep 1m
echo "$engineservice is starting"
#/opt/ibm/WEX/Engine/bin/engine-start
sleep 1m
echo "$zookeeperservice is starting"
#/opt/ibm/WEX/ZooKeeper/zookeeper/bin/zkServer.sh start
sleep 1m
echo "$appbuilderservice is starting"
#/opt/ibm/WEX/AppBuilder/wlp/bin/server start AppBuilder -- clean

#if (( $(ps -ef | grep -v grep | grep $zookeeperservice | wc -l) > 0 ))
#then
#subject="$service at $host has been started"
#echo "$service at $host wasn't running and has been started" | mail -s "$subject" $email
#else
#subject="$service at $host is not running"
#echo "$service at $host is stopped and cannot be started!!!" | mail -s "$subject" $email
#fi
#fi
