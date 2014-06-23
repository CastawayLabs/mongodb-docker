FROM phusion/baseimage

ENV HOME /root

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list
RUN apt-get update
RUN apt-get install -y mongodb-org

EXPOSE 27017

ADD mongodb.conf /etc/mongod.conf
RUN /etc/init.d/mongod stop

RUN mkdir /etc/service/mongodb
ADD mongodb.sh /etc/service/mongodb/run

CMD ["/sbin/my_init"]
