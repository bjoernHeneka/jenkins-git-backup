FROM jenkins/jenkins:lts

MAINTAINER Bjoern Heneka <bheneka@codebee.de>

USER root

ADD init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

RUN date && \
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    date

USER ${user}

ENTRYPOINT  ["/sbin/tini", "--", "/usr/local/bin/init.sh"]
