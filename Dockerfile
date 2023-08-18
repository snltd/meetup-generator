FROM ruby:3.2-alpine
ADD Gemfile /app/
ADD Gemfile.lock /app/
ADD . /app
RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
    gem install bundler && \
    cd /app && \
    bundle config set without development && \
    bundle install && \
    apk del build-dependencies ruby-dev
RUN chown -R nobody:nogroup /app
USER nobody
EXPOSE 4567
WORKDIR /app

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
