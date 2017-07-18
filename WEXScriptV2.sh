#!/bin/bash

###edit the following
host=`hostname -f`
engineservice=/opt/ibm/WEX/Engine/java/jre/bin/java
appbuilderservice=AppBuilder
zookeeperservice=ZooKeeper
delayeachstep = 120
###stop editing

if (( $(ps -ef | grep -v grep | grep $appbuilderservice | wc -l) > 0 ))
then
echo "$appbuilderservice is running"
/opt/ibm/WEX/AppBuilder/wlp/bin/server stop AppBuilder
fi
sleep($delayeachstep)
if (( $(ps -ef | grep -v grep | grep $zookeeperservice | wc -l) > 0 ))
then
echo "$zookeeperservice is running"
/opt/ibm/WEX/ZooKeeper/zookeeper/bin/zkServer.sh stop
fi
sleep($delayeachstep)
if (( $(ps -ef | grep -v grep | grep $engineservice | wc -l) > 0 ))
then
echo "$engineservice is running"
/opt/ibm/WEX/Engine/bin/engine-shutdown
fi
sleep($delayeachstep)

/opt/ibm/WEX/Engine/bin/engine-start
sleep($delayeachstep)
/opt/ibm/WEX/ZooKeeper/zookeeper/bin/zkServer.sh start
sleep($delayeachstep)
/opt/ibm/WEX/AppBuilder/wlp/bin/server start AppBuilder -- clean
sleep($delayeachstep)

#if (( $(ps -ef | grep -v grep | grep $zookeeperservice | wc -l) > 0 ))
#then
#subject="$service at $host has been started"
#echo "$service at $host wasn't running and has been started" | mail -s "$subject" $email
#else
#subject="$service at $host is not running"
#echo "$service at $host is stopped and cannot be started!!!" | mail -s "$subject" $email
#fi
#fi
