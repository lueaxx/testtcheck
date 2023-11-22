# Dockerfile
FROM httpd

# Habilitar módulo http2
RUN echo "LoadModule http2_module modules/mod_http2.so" >> /usr/local/apache2/conf/httpd.conf && \
    echo "Protocols h2 https/2" >> /usr/local/apache2/conf/httpd.conf

# Copiar los archivos de la página web al contenedor
COPY ./website/ /usr/local/apache2/htdocs/

# Copiar certificado y clave privada
COPY server.crt /usr/local/apache2/conf/server.crt
COPY server.key /usr/local/apache2/conf/server.key

# Habilitar SSL y configurar Apache para usar el certificado y la clave privada
RUN echo "LoadModule ssl_module modules/mod_ssl.so" >> /usr/local/apache2/conf/httpd.conf && \
    echo "Listen 443" >> /usr/local/apache2/conf/httpd.conf && \
    echo "<VirtualHost *:443>" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    SSLEngine on" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    SSLCertificateFile /usr/local/apache2/conf/server.crt" >> /usr/local/apache2/conf/httpd.conf && \
    echo "    SSLCertificateKeyFile /usr/local/apache2/conf/server.key" >> /usr/local/apache2/conf/httpd.conf && \
    echo "</VirtualHost>" >> /usr/local/apache2/conf/httpd.conf
