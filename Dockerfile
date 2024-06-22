FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
      libzip-dev \
      zip \
      wget \
      git \
      sqlite3 \
      libsqlite3-dev \

     && docker-php-ext-install pdo pdo_mysql zip

ADD ./docker/install-composer.sh /install-composer.sh
RUN chmod +x /install-composer.sh && /install-composer.sh && rm -f /install-composer.sh
RUN composer self-update
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony
RUN export PATH="$HOME/.symfony5/bin:$PATH"
RUN docker-php-ext-install pdo pdo_mysql pdo_sqlite zip
RUN mkdir -p /var/www/var/data && chown -R www-data:www-data /var/www/var

WORKDIR /var/www

COPY . /var/www

RUN chown -R www-data:www-data /var/www