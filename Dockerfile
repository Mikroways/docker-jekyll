FROM ruby:2.3.1

MAINTAINER Leandro Di Tommaso <leandro.ditommaso@mikroways.net>

ENV DEBIAN_FRONTEND noninteractive

RUN gem install bundle   && \
    gem install jekyll

VOLUME ["/data"]

ADD ./generate-html.sh /bin/
RUN chmod +x /bin/generate-html.sh
ENTRYPOINT ["/bin/generate-html.sh"]
