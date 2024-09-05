# Use the official NGINX image as the base image
FROM nginx:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y git build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev ffmpeg

# Clone nginx-rtmp-module
RUN git clone https://github.com/arut/nginx-rtmp-module.git /tmp/nginx-rtmp-module

# Download and extract NGINX source
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    cd nginx-1.21.6 && \
    ./configure --add-module=/tmp/nginx-rtmp-module --with-http_ssl_module && \
    make && \
    make install

# Copy the custom nginx configuration file
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# Copy the RTMP stat stylesheet
COPY stat.xsl /usr/local/nginx/html/stat.xsl

# Expose ports
EXPOSE 1935 8080

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]