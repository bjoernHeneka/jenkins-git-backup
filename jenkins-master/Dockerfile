FROM jenkins:2.46.1-alpine

MAINTAINER Bjoern Heneka <bheneka@codebee.de>

USER root

ADD init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

USER ${user}

ENTRYPOINT  ["/bin/tini", "--", "/usr/local/bin/init.sh"]
