FROM sameersbn/squid:latest
MAINTAINER johan@linkdata.se

ENV SQUID_USER=proxy \
    SQUIDGUARD_DB_DIR=/var/lib/squidguard/db \
    SQUIDGUARD_BLACKLIST_URL=http://www.shallalist.de/Downloads/shallalist.tar.gz

RUN apt-get update \
 && apt-get install -y dnsmasq squidguard

ADD dnsmasq.conf /etc/dnsmasq.conf
ADD block.html /var/www/html/block.html
ADD squidGuard.sh /sbin/squidGuard.sh
ADD squidGuard.conf /etc/squidguard/squidGuard.conf

RUN chmod 755 /sbin/squidGuard.sh

RUN echo "dns_v4_first on" >> /etc/squid3/squid.conf
RUN echo "dns_nameservers 127.0.0.2" >> /etc/squid3/squid.conf
RUN echo "forwarded_for off" >> /etc/squid3/squid.conf
RUN echo "redirect_program /usr/bin/squidGuard -c /etc/squidguard/squidGuard.conf" >> /etc/squid3/squid.conf

EXPOSE 3128/tcp

CMD ["/sbin/squidGuard.sh"]
