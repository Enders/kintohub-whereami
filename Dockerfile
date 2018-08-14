FROM ruby:2.5

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY . ./

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "server.rb", "-o", "0.0.0.0"]
