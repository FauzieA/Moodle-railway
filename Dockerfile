FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl pdo pdo_pgsql pgsql

RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html

RUN mkdir -p /var/www/moodledata && chown -R www-data:www-data /var/www/moodledata

RUN echo "max_input_vars = 5000" > /usr/local/etc/php/conf.d/custom.ini && \
    echo "upload_max_filesize = 20M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "post_max_size = 20M" >> /usr/local/etc/php/conf.d/custom.ini

EXPOSE 80

# Optional: ensure Apache looks for index.php
RUN echo "DirectoryIndex index.php" >> /etc/apache2/apache2.conf

# ✅ Start Apache in foreground (Railway needs this)
CMD ["apache2-foreground"]
