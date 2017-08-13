FROM alpine:3.6
MAINTAINER Alessandro Giangreco <alessandro.giangreco@gmail.com>
ENV ALPINE_VERSION=3.6

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/web2py \
    USER_NAME=web2py \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}  PATH=$PATH:${APP_ROOT}

RUN mkdir -p ${APP_HOME}
COPY src/web2py/ ${APP_ROOT}/
COPY bin/run ${APP_ROOT}/
COPY cert ${APP_ROOT}/

RUN date >${APP_ROOT}/timestamp

RUN chmod -R u+x ${APP_ROOT} && \
    echo "${USER_NAME}:x:${USER_UID}:0:${USER_NAME}:${APP_ROOT}:/sbin/nologin" >>/etc/passwd && \
    chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT}

####### Add app-specific needs below. #######
# Install needed packages. Notes:
#   * dumb-init: a proper init system for containers, to reap zombie children
#   * musl: standard C library
#   * linux-headers: commonly needed, and an unusual package name from Alpine.
#   * build-base: used so we include the basic development packages (gcc)
#   * bash: so we can access /bin/bash
#   * git: to ease up clones of repos
#   * ca-certificates: for SSL verification during Pip and easy_install
#   * python: the binaries themselves
#   * python-dev: are used for gevent e.g.
#   * py-setuptools: required only in major version 2, installs easy_install so we can install Pip.
ENV PACKAGES="\
  dumb-init \
  musl \
  linux-headers \
  build-base \
  bash \
  git \
  ca-certificates \
  python2 \
  python2-dev \
  py-setuptools \
"

RUN echo \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \

  # Add the packages, with a CDN-breakage fallback if needed
  && apk add --no-cache $PACKAGES || \
    (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache $PACKAGES) \

  # turn back the clock -- so hacky!
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/" > /etc/apk/repositories \
  # && echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  # && echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  # && echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \

  # make some useful symlinks that are expected to exist
  && if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python2.7 /usr/bin/python; fi \
  && if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python2.7-config /usr/bin/python-config; fi \
  && if [[ ! -e /usr/bin/easy_install ]];  then ln -sf /usr/bin/easy_install-2.7 /usr/bin/easy_install; fi \

  # Install and upgrade Pip
  && easy_install pip \
  && pip install --upgrade pip \
  && if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip2.7 /usr/bin/pip; fi \
  && echo

# env vars
ENV PW admin
ENV CERT_PASS web2py

# port exposed

EXPOSE 8000

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}
#VOLUME ${APP_ROOT}
#RUN python -c "from gluon.main import save_password; save_password('$PW',80)" && \
#	python -c "from gluon.main import save_password; save_password('$PW',443)" && \
#  python -c "from gluon.main import save_password; save_password('$PW',8000)"

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD run
