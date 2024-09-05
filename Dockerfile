FROM alpine:3.14

# Install necessary dependencies (excluding ffmpeg)
RUN apk add --no-cache \
    build-base \
    pcre-dev \
    openssl-dev \
    zlib-dev \
    linux-headers \
    wget \
    git

# Download and extract NGINX
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    cd nginx-1.21.6

# Clone nginx-rtmp-module
RUN git clone https://github.com/arut/nginx-rtmp-module.git /tmp/nginx-rtmp-module

# Compile NGINX with RTMP module
RUN cd nginx-1.21.6 && \
    ./configure \
    --prefix=/usr/local/nginx \
    --add-module=/tmp/nginx-rtmp-module \
    --with-http_ssl_module \
    --with-cc-opt="-Wimplicit-fallthrough=0" && \
    make && \
    make install

# Copy the NGINX configuration file
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# Copy the RTMP stat stylesheet
COPY stat.xsl /usr/local/nginx/html/stat.xsl

# Create necessary directories
RUN mkdir -p /tmp/hls

EXPOSE 1935 8080

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]