FROM php:7.4-fpm-alpine

# Package refresh
# Laravel + MySQLが使えるようになる依存モジュールのインストール
RUN apk update && apk upgrade
RUN apk add --no-cache libzip-dev zip freetype libpng libjpeg libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip && docker-php-ext-install pdo_mysql 

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions gd
RUN docker-php-ext-configure gd \
    --enable-gd \
    --with-zlib \
    --with-freetype \
    --with-png-dir=/usr/include/ \
    --with-jpeg && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd

  # Postgres用
  # RUN set -ex \
	# && apk --no-cache add postgresql-libs postgresql-dev \
	# && docker-php-ext-install pgsql pdo_pgsql \
	# && apk del postgresql-dev

# composer install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === rtrim(file_get_contents('https://composer.github.io/installer.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer

# Delete default Config file and Add Original config files
COPY php-fpm.conf /usr/local/etc/php-fpm.conf

# Default Directory Settings
RUN mkdir -p /var/www/app
WORKDIR /var/www/app
