FROM ubuntu:14.04

EXPOSE 8091
ENV PATH=$PATH:/opt/couchbase/bin

RUN apt-get update -yq && apt-get upgrade -yq && apt-get install -yq python curl
RUN curl -L -sS http://packages.couchbase.com/releases/4.0.0/couchbase-server-community_4.0.0-ubuntu14.04_amd64.deb > /tmp/couchbase.deb && \
    dpkg -x /tmp/couchbase.deb /tmp/couchbase && \
    mv /tmp/couchbase/opt/couchbase /opt/couchbase && \
    rm /tmp/couchbase.deb && rm -rf /tmp/couchbase

ADD docker-entrypoint.sh /opt/couchbase/bin/
CMD ["docker-entrypoint.sh"]