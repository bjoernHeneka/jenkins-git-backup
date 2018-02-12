FROM jenkins/jenkins:2.89.3-alpine

MAINTAINER Bjoern Heneka <bheneka@codebee.de>

USER root

ADD init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

USER ${user}

ENTRYPOINT  ["/sbin/tini", "--", "/usr/local/bin/init.sh"]
