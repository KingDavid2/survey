FROM ruby:3.1.0-alpine

RUN apk add --no-cache build-base bash nodejs postgresql-dev yarn tzdata shared-mime-info

WORKDIR /app

RUN gem install bundler:2.3.10

COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install

COPY package.json ./
COPY yarn.lock ./
RUN yarn install --network-timeout=30000

ENV BUNDLE_GEMFILE=./Gemfile
ENV PATH=/app/bin:$PATH

EXPOSE 3000
