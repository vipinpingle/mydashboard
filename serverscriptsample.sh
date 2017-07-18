
ps -ef | grep AppBuilder
ps -ef | grep ZooKeeper
ps -ef | grep /opt/ibm/WEX/Engine/java/jre/bin/java

#!/bin/sh

# service name
SERVICE_NAME=Liferay
# directory where are stored service bin
SERVICE_DIRECTORY=/opt/Portal/bin
# startup service script
SERVICE_STARTUP_SCRIPT=startup.sh
# stop service script
SERVICE_SHUTDOWN_SCRIPT=shutdown.sh

usage()
{
        echo "-----------------------"
        echo "Usage: $0 (stop|start|restart)"
        echo "-----------------------"
}

if [ -z $1 ]; then
        usage
fi

service_start()
{
        echo "Starting service '${SERVICE_NAME}'..."
        OWD=`pwd`
        cd ${SERVICE_DIRECTORY} &amp;&amp; ./${SERVICE_STARTUP_SCRIPT}
        cd $OWD
        echo "Service '${SERVICE_NAME}' started successfully"
}

service_stop()
{
        echo "Stopping service '${SERVICE_NAME}'..."
        OWD=`pwd`
        cd ${SERVICE_DIRECTORY} &amp;&amp; ./${SERVICE_SHUTDOWN_SCRIPT}
        cd $OWD
        echo "Service '${SERVICE_NAME}' stopped"
}

case $1 in
        stop)
                service_stop
        ;;
        start)
                service_start
        ;;
        restart)
                service_stop
                service_start
        ;;
        *)
                usage
esac
exit 0
