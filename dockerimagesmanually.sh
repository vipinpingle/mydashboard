OPENSHIFT_REL=v3.10
OPTIONAL_REL=v3.10.72
REGISTRY=registry.access.redhat.com

# fetch openshift-origin images
echo "Starting the script"
echo \
${REGISTRY}/openshift3/csi-attacher:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/csi-driver-registrar:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/csi-livenessprobe:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/csi-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/image-inspector:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/local-storage-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/manila-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-ansible:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-cli:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-cluster-capacity:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-deployer:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-descheduler:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-docker-builder:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-docker-registry:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-egress-dns-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-egress-http-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-egress-router:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-f5-router:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-haproxy-router:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-hyperkube:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-hypershift:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-keepalived-ipfailover:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-pod:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-node-problem-detector:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-recycler:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-web-console:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-node:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-control-plane:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/registry-console:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/snapshot-controller:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/snapshot-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/apb-base:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/apb-tools:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-service-catalog:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-ansible-service-broker:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/mariadb-apb:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/mediawiki-apb:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/mysql-apb:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-template-service-broker:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/postgresql-apb:${OPENSHIFT_REL} \
${REGISTRY}/rhel7/etcd:3.2.22 \
${REGISTRY}/openshift3/efs-provisioner:${OPENSHIFT_REL} \
| xargs -n1 docker pull


echo "Sleeping for 10 seconds"
sleep 10

echo "Downloading optional components"
echo \
${REGISTRY}/openshift3/logging-auth-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-curator:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-elasticsearch:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-eventrouter:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-fluentd:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-kibana:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/oauth-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-cassandra:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-hawkular-metrics:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-hawkular-openshift-agent:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-heapster:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-schema-installer:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus-alert-buffer:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus-alertmanager:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus-node-exporter:${OPENSHIFT_REL} \
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
${REGISTRY}/openshift3/jenkins-1-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-2-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-agent-maven-35-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-agent-nodejs-8-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-slave-base-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-slave-maven-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-slave-nodejs-rhel7:${OPENSHIFT_REL} \
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
${REGISTRY}/openshift3/csi-attacher:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/csi-driver-registrar:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/csi-livenessprobe:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/csi-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/image-inspector:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/local-storage-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/manila-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-ansible:${OPENSHIFT_REL} \
| xargs docker save -o ose311-images1.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/openshift3/ose-cli:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-cluster-capacity:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-deployer:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-descheduler:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-docker-builder:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-docker-registry:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-egress-dns-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-egress-http-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-egress-router:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-f5-router:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-haproxy-router:${OPENSHIFT_REL} \
| xargs docker save -o ose311-images2.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/openshift3/ose-hyperkube:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-hypershift:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-keepalived-ipfailover:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-pod:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-node-problem-detector:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-recycler:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-web-console:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-node:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-control-plane:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/registry-console:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/snapshot-controller:${OPENSHIFT_REL} \
| xargs docker save -o ose311-images3.tar

echo "Sleeping for 10 seconds"
sleep 10

echo \
${REGISTRY}/openshift3/snapshot-provisioner:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/apb-base:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/apb-tools:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-service-catalog:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-ansible-service-broker:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/mariadb-apb:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/mediawiki-apb:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/mysql-apb:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/ose-template-service-broker:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/postgresql-apb:${OPENSHIFT_REL} \
${REGISTRY}/rhel7/etcd:3.2.22 \
${REGISTRY}/openshift3/efs-provisioner:${OPENSHIFT_REL} \
| xargs docker save -o ose311-images4.tar

echo "Sleeping for 10 seconds"
sleep 10

echo "Saving the optional images"
echo \
${REGISTRY}/openshift3/logging-auth-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-curator:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-elasticsearch:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-eventrouter:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-fluentd:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/logging-kibana:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/oauth-proxy:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-cassandra:${OPENSHIFT_REL} \
| xargs docker save -o ose311-optional-images1.tar

echo "Sleeping for 10 seconds"
echo \
${REGISTRY}/openshift3/metrics-hawkular-metrics:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-hawkular-openshift-agent:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-heapster:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/metrics-schema-installer:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus-alert-buffer:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus-alertmanager:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/prometheus-node-exporter:${OPENSHIFT_REL} \
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
${REGISTRY}/openshift3/jenkins-1-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-2-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-agent-maven-35-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-agent-nodejs-8-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-slave-base-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-slave-maven-rhel7:${OPENSHIFT_REL} \
${REGISTRY}/openshift3/jenkins-slave-nodejs-rhel7:${OPENSHIFT_REL} \
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
