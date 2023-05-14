# Base image
FROM php:7.4-apache

# Set the working directory
WORKDIR /var/www/html

# Install required packages
RUN apt-get update && \
    apt-get install -y \
        wget \
        unzip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        && docker-php-ext-install -j$(nproc) \
            bcmath \
            gd \
            mysqli \
            opcache \
            pdo_mysql \
            zip

# Download and extract WordPress
RUN wget -q https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz

# Set the ownership and permissions of the WordPress files
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose the container port
EXPOSE 80

# Start Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
