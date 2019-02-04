# dtnews

FROM ruby:2.5.3-alpine

# Setting this to true will retain linux
# build tools and dev packages.
ARG developer_build=false
ARG RUBY_VERSION=2.5.3
ARG RUBY_MAJOR_VERSION=2.5.0
# Args for labels.
ARG VCS_REF
ARG BUILD_DATE

#Labels
LABEL maintainer="Giovanni Sakti, giosakti@gmail.com" \
      decription="dtnews" \
      version="latest" \
      org.label-schema.name="dtnews" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/deeptechid/dtnews-docker" \
      org.label-schema.schema-version="0.1.5"

# Create dtnews user and group.
RUN addgroup -S dtnews && adduser -S -h /dtnews -s /bin/sh -G dtnews dtnews

# Copy Gemfile to container.
COPY ./dtnews/Gemfile ./dtnews/Gemfile.lock /dtnews/

# Install needed runtime & development dependencies. If this is a developer_build we don't remove
# the build-deps after doing a bundle install.
RUN chown -R dtnews:dtnews /dtnews \
    && apk --no-cache --update --virtual deps add mariadb-connector-c-dev mariadb-connector-c sqlite-libs tzdata nodejs ncurses \
    && apk --no-cache --virtual build-deps add build-base gcc mariadb-dev linux-headers sqlite-dev git bash curl gnupg \
    && export PATH=/dtnews/.gem/ruby/$RUBY_MAJOR_VERSION/bin:$PATH \
    && export GEM_HOME="/dtnews/.gem" \
    && export GEM_PATH="/dtnews/.gem" \
    && export BUNDLE_PATH="/dtnews/.bundle" \
    && cd /dtnews \
    && su dtnews -c "curl -o- -L https://yarnpkg.com/install.sh | bash" \
    && su dtnews -c "gem install bundler --user-install" \
    && su dtnews -c "bundle install --no-cache" \
    && su dtnews -c "bundle add puma" \
    && if [ "${developer_build}" != "true" ]; then apk del build-deps; fi \
    && mv /dtnews/Gemfile /dtnews/Gemfile.bak \
    && mv /dtnews/Gemfile.lock /dtnews/Gemfile.lock.bak

# Copy dtnews into the container.
COPY ./dtnews ./docker-assets /dtnews/

# Set proper permissions and move assets and configs.
RUN mv /dtnews/Gemfile.bak /dtnews/Gemfile \
    && mv /dtnews/Gemfile.lock.bak /dtnews/Gemfile.lock \
    && chown -R dtnews:dtnews /dtnews \
    && mv /dtnews/docker-entrypoint.sh /usr/local/bin/ \
    && chmod 755 /usr/local/bin/docker-entrypoint.sh \
    && rm /dtnews/Gemfile.lock

# Drop down to unprivileged users
USER dtnews

# Set our working directory.
WORKDIR /dtnews/

# Set environment variables.
ENV MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306" \
    MARIADB_POOL="10" \
    MARIADB_USER="user" \
    MARIADB_PASSWORD="password" \
    DTNEWS_HOSTNAME="localhost" \
    DTNEWS_SITE_NAME="DTNews" \
    DTNEWS_DATABASE="dtnews" \
    RAILS_ENV="development" \
    SECRET_KEY="" \
    GEM_HOME="/dtnews/.gem" \
    GEM_PATH="/dtnews/.gem" \
    BUNDLE_PATH="/dtnews/.bundle" \
    RAILS_MAX_THREADS="5" \
    SMTP_HOST="127.0.0.1" \
    SMTP_PORT="25" \
    SMTP_STARTTLS_AUTO="true" \
    SMTP_USERNAME="dtnews" \
    SMTP_PASSWORD="dtnews" \
    RAILS_LOG_TO_STDOUT="1" \
    PATH="/dtnews/.gem/ruby/$RUBY_MAJOR_VERSION/bin:/dtnews/.yarn/bin:$PATH"

# Expose HTTP port.
EXPOSE 3000

# Execute our entry script.
CMD ["/usr/local/bin/docker-entrypoint.sh"]
