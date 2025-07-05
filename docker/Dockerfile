FROM ruby:2.7.1

WORKDIR /app

RUN apt-get update

RUN apt-get install -y software-properties-common 
RUN curl -sL https://deb.nodesource.com/setup_23.x | bash -

RUN apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

RUN gem install bundler -v 1.17.3

RUN apt-get -y install autoconf sqlite3

COPY ./Gemfile* /app

RUN bundler install

COPY . /app

RUN bundle exec rails webpacker:install:react
RUN sed -i '/plugins: \[/a \    "@babel\/plugin-proposal-optional-chaining",\n    "@babel\/plugin-proposal-nullish-coalescing-operator",' babel.config.js
# RUN cat babel.config.js
RUN NODE_OPTIONS=--openssl-legacy-provider bundle exec rails webpacker:compile