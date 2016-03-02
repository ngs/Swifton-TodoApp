FROM ubuntu:14.04
MAINTAINER a@ngs.io

ENV APP_DIR /var/www/app
RUN mkdir -p ${APP_DIR}
WORKDIR ${APP_DIR}
ADD . ${APP_DIR}

CMD .build/release/Swifton-TodoApp
