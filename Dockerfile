FROM ruby:2.1.1

RUN apt-get update -qq && apt-get install -y --force-yes build-essential mysql-client nodejs git libssl-dev vim
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
