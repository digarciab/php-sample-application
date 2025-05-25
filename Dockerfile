FROM php:7.1-apache

# Instala dependencias del sistema y Composer
RUN apt-get update && apt-get install -y git unzip curl \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && docker-php-ext-install pdo pdo_mysql

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia solo composer.json y composer.lock (si existe)
COPY composer.json composer.lock* ./

# Ejecuta composer install antes de copiar el resto
RUN composer install

# Ahora copia todo el código del proyecto (incluye src/, web/, dic/, etc.)
COPY . .

# Configura Apache para servir desde /var/www/web
RUN sed -i 's|/var/www/html|/var/www/web|g' /etc/apache2/sites-available/000-default.conf \
    && chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Habilita mod_rewrite para URLs amigables
RUN a2enmod rewrite

# Permite el uso de .htaccess dentro de /var/www/web
RUN echo '<Directory /var/www/web>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf

EXPOSE 80
