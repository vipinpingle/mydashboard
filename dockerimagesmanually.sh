OPENSHIFT_REL=v3.11
OPTIONAL_REL=v3.10.72
REGISTRY=registry.access.redhat.com

# fetch openshift-origin images
echo "Starting the script"
echo \
${REGISTRY}/openshift3/csi-attacher \
${REGISTRY}/openshift3/csi-driver-registrar \
${REGISTRY}/openshift3/csi-livenessprobe \
${REGISTRY}/openshift3/csi-provisioner \
${REGISTRY}/openshift3/image-inspector \
${REGISTRY}/openshift3/local-storage-provisioner \
${REGISTRY}/openshift3/manila-provisioner \
${REGISTRY}/openshift3/ose-ansible \
${REGISTRY}/openshift3/ose-cli \
${REGISTRY}/openshift3/ose-cluster-capacity \
${REGISTRY}/openshift3/ose-deployer \
${REGISTRY}/openshift3/ose-descheduler \
${REGISTRY}/openshift3/ose-docker-builder \
${REGISTRY}/openshift3/ose-docker-registry \
${REGISTRY}/openshift3/ose-egress-dns-proxy \
${REGISTRY}/openshift3/ose-egress-http-proxy \
${REGISTRY}/openshift3/ose-egress-router \
${REGISTRY}/openshift3/ose-f5-router \
${REGISTRY}/openshift3/ose-haproxy-router \
${REGISTRY}/openshift3/ose-hyperkube \
${REGISTRY}/openshift3/ose-hypershift \
${REGISTRY}/openshift3/ose-keepalived-ipfailover \
${REGISTRY}/openshift3/ose-pod \
${REGISTRY}/openshift3/ose-node-problem-detector \
${REGISTRY}/openshift3/ose-recycler \
${REGISTRY}/openshift3/ose-web-console \
${REGISTRY}/openshift3/ose-node \
${REGISTRY}/openshift3/ose-control-plane \
${REGISTRY}/openshift3/registry-console \
${REGISTRY}/openshift3/snapshot-controller \
${REGISTRY}/openshift3/snapshot-provisioner \
${REGISTRY}/openshift3/apb-base \
${REGISTRY}/openshift3/apb-tools \
${REGISTRY}/openshift3/ose-service-catalog \
${REGISTRY}/openshift3/ose-ansible-service-broker \
${REGISTRY}/openshift3/mariadb-apb \
${REGISTRY}/openshift3/mediawiki-apb \
${REGISTRY}/openshift3/mysql-apb \
${REGISTRY}/openshift3/ose-template-service-broker \
${REGISTRY}/openshift3/postgresql-apb \
${REGISTRY}/rhel7/etcd \
${REGISTRY}/openshift3/efs-provisioner \
| xargs -n1 docker pull


echo "Sleeping for 10 seconds"
sleep 10

echo "Downloading optional components"
echo \
${REGISTRY}/openshift3/logging-auth-proxy \
${REGISTRY}/openshift3/logging-curator \
${REGISTRY}/openshift3/logging-elasticsearch \
${REGISTRY}/openshift3/logging-eventrouter \
${REGISTRY}/openshift3/logging-fluentd \
${REGISTRY}/openshift3/logging-kibana \
${REGISTRY}/openshift3/oauth-proxy \
${REGISTRY}/openshift3/metrics-cassandra \
${REGISTRY}/openshift3/metrics-hawkular-metrics \
${REGISTRY}/openshift3/metrics-hawkular-openshift-agent \
${REGISTRY}/openshift3/metrics-heapster \
${REGISTRY}/openshift3/metrics-schema-installer \
${REGISTRY}/openshift3/prometheus \
${REGISTRY}/openshift3/prometheus-alert-buffer \
${REGISTRY}/openshift3/prometheus-alertmanager \
${REGISTRY}/openshift3/prometheus-node-exporter \
${REGISTRY}/cloudforms46/cfme-openshift-postgresql \
${REGISTRY}/cloudforms46/cfme-openshift-memcached \
${REGISTRY}/cloudforms46/cfme-openshift-app-ui \
${REGISTRY}/cloudforms46/cfme-openshift-app \
${REGISTRY}/cloudforms46/cfme-openshift-embedded-ansible \
${REGISTRY}/cloudforms46/cfme-openshift-httpd \
${REGISTRY}/cloudforms46/cfme-httpd-configmap-generator \
${REGISTRY}/rhgs3/rhgs-server-rhel7 \
${REGISTRY}/rhgs3/rhgs-volmanager-rhel7 \
${REGISTRY}/rhgs3/rhgs-gluster-block-prov-rhel7 \
${REGISTRY}/rhgs3/rhgs-s3-server-rhel7 \
| xargs -n1 docker pull

echo "Sleeping for 10 seconds"
sleep 10

echo "Downloading s2i images"
echo \
${REGISTRY}/jboss-amq-6/amq63-openshift \
${REGISTRY}/jboss-datagrid-7/datagrid71-openshift \
${REGISTRY}/jboss-datagrid-7/datagrid71-client-openshift \
${REGISTRY}/jboss-datavirt-6/datavirt63-openshift \
${REGISTRY}/jboss-datavirt-6/datavirt63-driver-openshift \
${REGISTRY}/jboss-decisionserver-6/decisionserver64-openshift \
${REGISTRY}/jboss-processserver-6/processserver64-openshift \
${REGISTRY}/jboss-eap-6/eap64-openshift \
${REGISTRY}/jboss-eap-7/eap70-openshift \
${REGISTRY}/jboss-webserver-3/webserver31-tomcat7-openshift \
${REGISTRY}/jboss-webserver-3/webserver31-tomcat8-openshift \
${REGISTRY}/openshift3/jenkins-1-rhel7 \
${REGISTRY}/openshift3/jenkins-2-rhel7 \
${REGISTRY}/openshift3/jenkins-agent-maven-35-rhel7 \
${REGISTRY}/openshift3/jenkins-agent-nodejs-8-rhel7 \
${REGISTRY}/openshift3/jenkins-slave-base-rhel7 \
${REGISTRY}/openshift3/jenkins-slave-maven-rhel7 \
${REGISTRY}/openshift3/jenkins-slave-nodejs-rhel7 \
${REGISTRY}/rhscl/mongodb-32-rhel7 \
${REGISTRY}/rhscl/mysql-57-rhel7 \
${REGISTRY}/rhscl/perl-524-rhel7 \
${REGISTRY}/rhscl/php-56-rhel7 \
${REGISTRY}/rhscl/postgresql-95-rhel7 \
${REGISTRY}/rhscl/python-35-rhel7 \
${REGISTRY}/redhat-sso-7/sso70-openshift \
${REGISTRY}/rhscl/ruby-24-rhel7 \
${REGISTRY}/redhat-openjdk-18/openjdk18-openshift \
${REGISTRY}/redhat-sso-7/sso71-openshift \
${REGISTRY}/rhscl/nodejs-6-rhel7 \
${REGISTRY}/rhscl/mariadb-101-rhel7 \
| xargs -n1 docker pull

echo "Sleeping for 10 seconds"
sleep 10

echo "Saving the core images"
echo \
${REGISTRY}/openshift3/csi-attacher \
${REGISTRY}/openshift3/csi-driver-registrar \
${REGISTRY}/openshift3/csi-livenessprobe \
${REGISTRY}/openshift3/csi-provisioner \
${REGISTRY}/openshift3/image-inspector \
${REGISTRY}/openshift3/local-storage-provisioner \
${REGISTRY}/openshift3/manila-provisioner \
${REGISTRY}/openshift3/ose-ansible \
| xargs docker save -o ose311-images1.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/openshift3/ose-cli \
${REGISTRY}/openshift3/ose-cluster-capacity \
${REGISTRY}/openshift3/ose-deployer \
${REGISTRY}/openshift3/ose-descheduler \
${REGISTRY}/openshift3/ose-docker-builder \
${REGISTRY}/openshift3/ose-docker-registry \
${REGISTRY}/openshift3/ose-egress-dns-proxy \
${REGISTRY}/openshift3/ose-egress-http-proxy \
${REGISTRY}/openshift3/ose-egress-router \
${REGISTRY}/openshift3/ose-f5-router \
${REGISTRY}/openshift3/ose-haproxy-router \
| xargs docker save -o ose311-images2.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/openshift3/ose-hyperkube \
${REGISTRY}/openshift3/ose-hypershift \
${REGISTRY}/openshift3/ose-keepalived-ipfailover \
${REGISTRY}/openshift3/ose-pod \
${REGISTRY}/openshift3/ose-node-problem-detector \
${REGISTRY}/openshift3/ose-recycler \
${REGISTRY}/openshift3/ose-web-console \
${REGISTRY}/openshift3/ose-node \
${REGISTRY}/openshift3/ose-control-plane \
${REGISTRY}/openshift3/registry-console \
${REGISTRY}/openshift3/snapshot-controller \
| xargs docker save -o ose311-images3.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/openshift3/snapshot-provisioner \
${REGISTRY}/openshift3/apb-base \
${REGISTRY}/openshift3/apb-tools \
${REGISTRY}/openshift3/ose-service-catalog \
${REGISTRY}/openshift3/ose-ansible-service-broker \
${REGISTRY}/openshift3/mariadb-apb \
${REGISTRY}/openshift3/mediawiki-apb \
${REGISTRY}/openshift3/mysql-apb \
${REGISTRY}/openshift3/ose-template-service-broker \
${REGISTRY}/openshift3/postgresql-apb \
${REGISTRY}/rhel7/etcd \
${REGISTRY}/openshift3/efs-provisioner \
| xargs docker save -o ose311-images4.tar

echo "Sleeping for 10 seconds"
sleep 10

echo "Saving the optional images"
echo \
${REGISTRY}/openshift3/logging-auth-proxy \
${REGISTRY}/openshift3/logging-curator \
${REGISTRY}/openshift3/logging-elasticsearch \
${REGISTRY}/openshift3/logging-eventrouter \
${REGISTRY}/openshift3/logging-fluentd \
${REGISTRY}/openshift3/logging-kibana \
${REGISTRY}/openshift3/oauth-proxy \
${REGISTRY}/openshift3/metrics-cassandra \
| xargs docker save -o ose311-optional-images1.tar

echo "Sleeping for 10 seconds"
echo \
${REGISTRY}/openshift3/metrics-hawkular-metrics \
${REGISTRY}/openshift3/metrics-hawkular-openshift-agent \
${REGISTRY}/openshift3/metrics-heapster \
${REGISTRY}/openshift3/metrics-schema-installer \
${REGISTRY}/openshift3/prometheus \
${REGISTRY}/openshift3/prometheus-alert-buffer \
${REGISTRY}/openshift3/prometheus-alertmanager \
${REGISTRY}/openshift3/prometheus-node-exporter \
${REGISTRY}/cloudforms46/cfme-openshift-postgresql \
| xargs docker save -o ose311-optional-images2.tar

echo "Sleeping for 10 seconds"
echo \
${REGISTRY}/cloudforms46/cfme-openshift-memcached \
${REGISTRY}/cloudforms46/cfme-openshift-app-ui \
${REGISTRY}/cloudforms46/cfme-openshift-app \
${REGISTRY}/cloudforms46/cfme-openshift-embedded-ansible \
${REGISTRY}/cloudforms46/cfme-openshift-httpd \
${REGISTRY}/cloudforms46/cfme-httpd-configmap-generator \
${REGISTRY}/rhgs3/rhgs-server-rhel7 \
${REGISTRY}/rhgs3/rhgs-volmanager-rhel7 \
${REGISTRY}/rhgs3/rhgs-gluster-block-prov-rhel7 \
${REGISTRY}/rhgs3/rhgs-s3-server-rhel7 \
| xargs docker save -o ose311-optional-images3.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/jboss-amq-6/amq63-openshift \
${REGISTRY}/jboss-datagrid-7/datagrid71-openshift \
${REGISTRY}/jboss-datagrid-7/datagrid71-client-openshift \
${REGISTRY}/jboss-datavirt-6/datavirt63-openshift \
${REGISTRY}/jboss-datavirt-6/datavirt63-driver-openshift \
${REGISTRY}/jboss-decisionserver-6/decisionserver64-openshift \
${REGISTRY}/jboss-processserver-6/processserver64-openshift \
${REGISTRY}/jboss-eap-6/eap64-openshift \
${REGISTRY}/jboss-eap-7/eap70-openshift \
| xargs docker save -o ose311-s2i-images1.tar

echo "Sleeping for 10 seconds"
sleep 10
echo \
${REGISTRY}/jboss-webserver-3/webserver31-tomcat7-openshift \
${REGISTRY}/jboss-webserver-3/webserver31-tomcat8-openshift \
${REGISTRY}/openshift3/jenkins-1-rhel7 \
${REGISTRY}/openshift3/jenkins-2-rhel7 \
${REGISTRY}/openshift3/jenkins-agent-maven-35-rhel7 \
${REGISTRY}/openshift3/jenkins-agent-nodejs-8-rhel7 \
${REGISTRY}/openshift3/jenkins-slave-base-rhel7 \
${REGISTRY}/openshift3/jenkins-slave-maven-rhel7 \
${REGISTRY}/openshift3/jenkins-slave-nodejs-rhel7 \
| xargs docker save -o ose311-s2i-images2.tar

echo "Sleeping for 10 seconds"
sleep 10
echo \
${REGISTRY}/rhscl/mongodb-32-rhel7 \
${REGISTRY}/rhscl/mysql-57-rhel7 \
${REGISTRY}/rhscl/perl-524-rhel7 \
${REGISTRY}/rhscl/php-56-rhel7 \
${REGISTRY}/rhscl/postgresql-95-rhel7 \
${REGISTRY}/rhscl/python-35-rhel7 \
${REGISTRY}/redhat-sso-7/sso70-openshift \
${REGISTRY}/rhscl/ruby-24-rhel7 \
${REGISTRY}/redhat-openjdk-18/openjdk18-openshift \
${REGISTRY}/redhat-sso-7/sso71-openshift \
${REGISTRY}/rhscl/nodejs-6-rhel7 \
${REGISTRY}/rhscl/mariadb-101-rhel7 \
| xargs docker save -o ose311-s2i-images3.tar
