# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ----------------------------
# Build stage
# ----------------------------
FROM base AS build

# 必要パッケージ + Node.js
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev libvips pkg-config curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Gem インストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# package.json / npm install
COPY package.json package-lock.json ./
RUN npm install

# アプリコードコピー
COPY . .

# bootsnap precompile
RUN bundle exec bootsnap precompile app/ lib/

# assets:precompile（DaisyUI対応）
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ----------------------------
# Final stage
# ----------------------------
FROM base

# 必要パッケージのみ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# build stage からコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# 権限設定
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

WORKDIR /rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
