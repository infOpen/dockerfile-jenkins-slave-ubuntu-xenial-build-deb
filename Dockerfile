FROM infopen/jenkins-slave-ubuntu-xenial:0.1.0
MAINTAINER Alexandre Chaussier <a.chaussier@infopen.pro>

# Install packages to build deb packages
RUN apt-get update && \
    apt-get install -y  build-essential=12.1ubuntu2 \
                        cdbs=0.4.130ubuntu2 \
                        curl=7.47.0-1ubuntu2 \
                        debhelper=9.20160115ubuntu3 \
                        debootstrap=1.0.78+nmu1ubuntu1 \
                        devscripts=2.16.2ubuntu3 \
                        dh-make=2.201604 \
                        fakeroot=1.20.2-1ubuntu1 \
                        lintian=2.5.43 \
                        pbuilder=0.223

# Create user for build
RUN useradd -m \
            -s /bin/bash \
            build-user

# Set password for jenkins user
RUN echo "build-user:build-user" | chpasswd

# Get gosu GPG key
RUN gpg --keyserver ha.pool.sks-keyservers.net \
        --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

# Install Gosu
ENV GOSU_VERSION 1.9
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
 && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc" \
 && gpg --verify /usr/local/bin/gosu.asc \
 && rm /usr/local/bin/gosu.asc \
 && chown root:jenkins /usr/local/bin/gosu \
 && chmod 4750 /usr/local/bin/gosu
