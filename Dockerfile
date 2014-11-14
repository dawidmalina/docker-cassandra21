##
# CentOS 7 with cassandra21
##
FROM dawidmalina/docker-java8
MAINTAINER Dawid Malinowski <dawidmalina@gmail.com>

ENV REFRESHED_AT 2014-11-11

ADD start.sh /bin/start.sh
ADD create-db.sh /bin/create-db.sh

ADD datastax.repo /etc/yum.repos.d/datastax.repo

RUN yum -y install cassandra21-tools dsc21 datastax-agent hostname

VOLUME ["/var/lib/cassandra/data", "/var/lib/cassandra/commitlog"]

EXPOSE 7199 7000 7001 9160 9042

CMD ["start.sh"]
