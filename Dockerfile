FROM ubuntu:14.04
MAINTAINER ilkosta Costantino Giuliodori <costantino.giuliodori@gmail.com>

ENV POSTGREST_VERSION 0.3.0.2
ENV POSTGREST_DBHOST  host
ENV POSTGREST_DBPORT  5432
ENV POSTGREST_DBNAME  database
ENV POSTGREST_DBUSER  user
ENV POSTGREST_DBPASS  password
ENV POSTGREST_SCHEMA  public
ENV POSTGREST_ANONUSER postgres
ENV POSTGREST_SECRET  vediamosefunziona
ENV POSTGREST_PORT	3000


COPY 01prox /etc/apt/apt.conf.d/01prox

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update \
 && apt-get install -y \
	tar \ 
	xz-utils \
	wget \
	libpq-dev \
	libgmp10 

ADD http://github.com/begriffs/postgrest/releases/download/v${POSTGREST_VERSION}/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz /tmp/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz
RUN tar -xaf /tmp/postgrest-${POSTGREST_VERSION}-ubuntu.tar.xz \
 && mv postgrest /usr/local/bin/postgrest \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3000

CMD postgrest postgres://${POSTGREST_DBUSER}:${POSTGREST_DBPASS}@${POSTGREST_DBHOST}:${POSTGREST_DBPORT}/${POSTGREST_DBNAME} \
              --port ${POSTGREST_PORT} \
              --schema ${POSTGREST_SCHEMA} \
              --anonymous ${POSTGREST_ANONUSER} \
              --pool 200  
