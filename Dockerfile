FROM ubuntu:14.04
MAINTAINER a@ngs.io

RUN apt-get update && apt-get install -y libicu52 libxml2 curl && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APP_DIR /var/www/app
RUN mkdir -p ${APP_DIR}
WORKDIR ${APP_DIR}
ADD . ${APP_DIR}
RUN ln -s ${APP_DIR}/swift/usr/lib/swift/linux/*.so /usr/lib

EXPOSE 8000
CMD .build/release/Swifton-TodoApp
