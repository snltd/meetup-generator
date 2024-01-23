FROM ruby:3.2-alpine as build
COPY . /app
WORKDIR /app
RUN apk update -U
RUN apk add ruby-dev build-base 
RUN gem install bundler 
RUN bundle config set without development 
RUN bundle config set deployment true 
RUN bundle package 

FROM ruby:3.2-alpine as deploy
RUN apk update -U
COPY --from=build /app /app
WORKDIR /app
RUN bundle config set --local deployment true
RUN bundle config set without development 
RUN bundle install 
EXPOSE 8080
USER nobody
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8080"]
