FROM debian:wheezy
MAINTAINER Stan <teftin@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y php5 php5-cli php5-curl php5-gd php5-mysqlnd php5-xcache php5-fpm nginx runit

ADD https://github.com/gothfox/Tiny-Tiny-RSS/archive/1.15.3.tar.gz /opt/
RUN cd /opt && tar xzf 1.15.3.tar.gz
ADD config.php /opt/Tiny-Tiny-RSS-1.15.3/
RUN chown -R www-data:www-data /opt/Tiny-Tiny-RSS-1.15.3/lock
RUN chown -R www-data:www-data /opt/Tiny-Tiny-RSS-1.15.3/cache
RUN chown -R www-data:www-data /opt/Tiny-Tiny-RSS-1.15.3/feed-icons

RUN sed -i.bak -e '/daemonize/c\daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN rm /etc/nginx/sites-enabled/default
ADD tt-rss.conf /etc/nginx/conf.d/

ADD sv /opt/sv

EXPOSE 80
CMD exec runsvdir /opt/sv
