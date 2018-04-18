FROM starefossen/ruby-node:2-8-alpine

WORKDIR /app

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    icu-dev \
    libidn-dev \
    libressl \
    libtool \
    postgresql-dev \
    tzdata \
 && update-ca-certificates \
 && rm -rf /tmp/* /var/cache/apk/*

COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN bundle config build.nokogiri --with-iconv-lib=/usr/local/lib --with-iconv-include=/usr/local/include \
 && bundle install -j$(getconf _NPROCESSORS_ONLN) --deployment --without test development \
 && yarn --pure-lockfile \
 && yarn cache clean

COPY . ./

VOLUME /app/public/system /app/public/assets /app/public/packs

EXPOSE 3000

ENV RAILS_ENV=production

# This scripts runs `rake db:create` and `rake db:migrate` before
# running the command given
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
