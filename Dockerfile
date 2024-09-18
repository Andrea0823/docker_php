# Usa una imagen base de Ubuntu
FROM ubuntu:22.04

# Establece la zona horaria a México
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Mexico_City

# Actualiza la lista de paquetes e instala las dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
    tzdata \
    apache2 \
    php \
    libapache2-mod-php \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -fs /usr/share/zoneinfo/America/Mexico_City /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Copia los archivos de la aplicación al contenedor
COPY ./webapp /var/www/html/

# Configura el nombre del servidor para evitar advertencias
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Habilita el módulo de PHP en Apache
RUN a2enmod php8.1

# Expone el puerto 80 en el que Apache está ejecutando
EXPOSE 80

# Inicia Apache en primer plano
CMD ["apache2ctl", "-D", "FOREGROUND"]
