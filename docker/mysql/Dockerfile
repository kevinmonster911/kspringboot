FROM ubuntu:14.04
MAINTAINER kevinmonster

# set non interactive when apt install
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y mysql-server-5.7
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

VOLUME ["/var/lib/mysql"]
CMD ["/usr/local/bin/run"]