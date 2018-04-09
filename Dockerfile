FROM ruby:2.3-alpine
ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN apk --update add --virtual build-dependencies ruby-dev build-base && \
  gem install bundler --no-ri --no-rdoc && \
  cd /app; bundle install --without development && \
  apk del build-dependencies
ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody
EXPOSE 4567
WORKDIR /app

CMD ["bundle", "exec", "server.rb"]
