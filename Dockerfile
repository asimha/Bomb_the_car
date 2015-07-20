FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
ADD . ~/Bomb_the_car
WORKDIR ~/Bomb_the_car
ADD Gemfile ~/Bomb_the_car/Gemfile
RUN bundle install
ADD . ~/Bomb_the_car