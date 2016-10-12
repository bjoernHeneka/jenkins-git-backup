#! /bin/bash -e

interval=5
((end_time=${SECONDS}+3600))

while [ ! -d /var/jenkins_home/.git ] || [ ! -f /var/jenkins_home/config.xml ]
do
    echo "Checkout not done. Seelping ${interval}s for ${SECONDS}"
    sleep ${interval}
done

/bin/tini -- /usr/local/bin/jenkins.sh