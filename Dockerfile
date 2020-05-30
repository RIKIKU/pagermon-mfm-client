FROM ubuntu:latest

MAINTAINER Kyle Smith
ENV DEBIAN_FRONTEND noninteractive
ENV NODE_ENV production

#install required packages

RUN apt-get update && apt-get -y install \
    build-essential \
    git \
    libjansson-dev \
    libck-dev \
    cmake \
    python \
    pkg-config \
    librtlsdr-dev \
    npm \
    libx11-dev \
    libpulse-dev \
    && apt-get clean


#install TSL
RUN git clone https://github.com/pvachon/tsl.git /tmp/tsl \
    && mkdir /tmp/tsl/build \
    && cd /tmp/tsl/build \
    && cmake .. \
    && make \
    && make install


#git clone https://github.com/pvachon/tsl-sdr.git /tmp/tsl-sdr
RUN git clone https://github.com/RIKIKU/tsl-sdr.git /tmp/tsl-sdr \
    && cd /tmp/tsl-sdr \
    && git checkout --track origin/fixUbuntuMake \
    && mkdir /tmp/tsl-sdr/build \
    && cd /tmp/tsl-sdr/build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make \
    && make install


#Install Multimon-NG
RUN git clone https://github.com/EliasOenal/multimon-ng.git /tmp/multimon-ng \
    && mkdir /tmp/multimon-ng/build \
    && cd /tmp/multimon-ng/build \
    && cmake .. \
    && make \
    && make install

RUN git clone https://github.com/pagermon/pagermon.git /tmp/pagermon

RUN apt-get remove -y \
    build-essential \
    git \
    cmake
ADD . /app

WORKDIR /app

RUN cp -r /tmp/pagermon/client/. /app

RUN npm install

VOLUME ["/data"]


CMD ["sh","/app/entrypoint.sh"]
