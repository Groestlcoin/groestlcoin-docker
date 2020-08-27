FROM debian:stretch-slim

ARG TZ=Europe/Paris
ARG GRS_USER=grs
ARG GRS_UID=1000
ARG GRS_VERSION=2.20.1
ARG GRS_ARCHIVE=groestlcoin-${GRS_VERSION}-x86_64-linux-gnu.tar.gz
ARG GRS_SUM=0a877be9dac14f4d9aab95d6bfd51547275acbcc3e6553f0cb82c5c9f35f333c
ARG GRS_URL=https://github.com/Groestlcoin/groestlcoin/releases/download/v${GRS_VERSION}/${GRS_ARCHIVE}

ENV TZ $TZ

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN useradd -m -u $GRS_UID $GRS_USER \
  && apt-get -qq update \
  && apt-get -qq install wget rsync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q ${GRS_URL} \
  && sha256sum ${GRS_ARCHIVE} | grep -q ${GRS_SUM} \
  && tar -zxf ${GRS_ARCHIVE} \
  && rsync -ar groestlcoin-${GRS_VERSION}/ /usr/local \
  && rm -rf ${GRS_ARCHIVE} groestlcoin-${GRS_VERSION}

EXPOSE 1331

USER $GRS_USER
WORKDIR /home/$GRS_USER

CMD ["groestlcoind"]
