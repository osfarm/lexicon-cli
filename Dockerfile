FROM ruby:3.2-bullseye

ENV USER=lexicon-cli
ENV UID=1000
ENV GID=1000

RUN mkdir /lexicon-cli && \
    addgroup --gid "$GID" "$USER" && \
    adduser \
        --disabled-password \
        --gecos "" \
        --home /lexicon-cli \
        --ingroup "$USER" \
        --no-create-home \
        --uid "$UID" \
        "$USER" && \
    apt-get update && \
    apt-get -y install postgis postgresql-client postgresql-contrib libpq-dev p7zip-full pigz libyajl-dev --no-install-recommends

WORKDIR /lexicon-cli

ENV BUNDLE_PATH=/lexicon-cli/vendor/bundle \
    BUNDLER_VERSION='2.2.33'
RUN gem install bundler -v $BUNDLER_VERSION
COPY Gemfile /lexicon-cli/
RUN bundle install --jobs $(nproc) --path vendor/bundle

ADD . /lexicon-cli/
RUN chown -R lexicon-cli:lexicon-cli /lexicon-cli

USER lexicon-cli
