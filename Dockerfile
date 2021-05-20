FROM ubuntu:focal
MAINTAINER Filmon <filmon@hissing-skuz.de>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8

RUN apt-get -qqqy update
RUN apt-get -qqqy install apt-utils software-properties-common dctrl-tools

RUN apt-get -qqqy update && apt-get -qqqy dist-upgrade && apt-get -qqqy install kea-admin kea-common  kea-dhcp-ddns-server

VOLUME ["/etc/kea", "/var/cache/bind", "/var/lib/kea", "/var/log/kea"]

RUN mkdir -p /etc/kea-ddns && chown root:_kea /etc/kea-ddns/ && chmod 755 /etc/kea-ddns
RUN mkdir -p /var/log/kea && chown _kea:_kea /var/log/kea && chmod 755 /var/log/kea
RUN mkdir -p /run/kea && chown _kea:_kea /run/kea && chmod 755 /run/kea
RUN mkdir -p /etc/kea-ddns-keys && chown _kea:_kea /etc/kea-ddns-keys && chmod 755 /etc/kea-ddns-keys
RUN mkdir -p /etc/kea-ddns-forward && chown _kea:_kea /etc/kea-ddns-forward && chmod 755 /etc/kea-ddns-forward
RUN mkdir -p /etc/kea-ddns-reverse && chown _kea:_kea /etc/kea-ddns-reverse && chmod 755 /etc/kea-ddns-reverse

COPY tsig.keys /etc/kea-ddns-keys/tsig.keys
RUN chown _kea:_kea /etc/kea-ddns-keys/tsig.keys && chmod 660 /etc/kea-ddns-keys/tsig.keys
COPY  kea-ddns.forward /etc/kea-ddns-forward/kea-ddns.forward
RUN chown _kea:_kea /etc/kea-ddns-forward/kea-ddns.forward && chmod 664 /etc/kea-ddns-forward/kea-ddns.forward
COPY  kea-ddns.reverse /etc/kea-ddns-reverse/kea-ddns.reverse
RUN chown _kea:_kea /etc/kea-ddns-reverse/kea-ddns.reverse && chmod 664 /etc/kea-ddns-reverse/kea-ddns.reverse

ENV DDNS_PORT 53001
ENV DDNS_IP 0.0.0.0
# set the DEBUG flag to an integer to enable debugging
ENV DEBUG NO

EXPOSE $DDNS_PORT/tcp

COPY kea-dhcp-ddns.conf.tmpl  /etc/kea-ddns/kea-dhcp-ddns.conf.tmpl

COPY entrypoint.sh  /sbin
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/kea-dhcp-ddns"]
