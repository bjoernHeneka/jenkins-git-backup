#! /bin/bash -e

interval=5
((end_time=${SECONDS}+3600))

while [ ! -d /var/jenkins_home/.git ] || [ ! -f /var/jenkins_home/config.xml ]
do
    if [ "$SECONDS" -ge "$end_time" ]; then
        echo "Checkout still not done after ${SECONDS}s. Exiting jenkins master now"
        exit 1
    else
        echo "Checkout not done. Seelping ${interval}s for ${SECONDS}s/${end_time}s"
        sleep ${interval}
    fi
done

/sbin/tini -- /usr/local/bin/jenkins.sh
