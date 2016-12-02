FROM jenkins:2.19.4

MAINTAINER Bjoern Heneka <bheneka@codebee.de>

USER root

ADD init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

USER ${user}

ENTRYPOINT  ["/bin/tini", "--", "/usr/local/bin/init.sh"]
