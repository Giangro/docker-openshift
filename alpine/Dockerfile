FROM docker.io/alpine:latest
MAINTAINER Alessandro Giangreco <alessandro.giangreco@gmail.com>

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=10001
ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_HOME} && mkdir -p ${APP_ROOT}/logs && mkdir -p ${APP_ROOT}/data
COPY bin/ ${APP_ROOT}/bin/
RUN date >>${APP_ROOT}/logs/timestamp
RUN chmod -R u+x ${APP_ROOT}/bin && \
    echo "${USER_NAME}:x:${USER_UID}:0:${USER_NAME}:${APP_ROOT}:/sbin/nologin" >>/etc/passwd && \
    chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT}

####### Add app-specific needs below. #######
### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}
VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data
CMD run
