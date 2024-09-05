# 使用 nvidia/cuda 作為基礎映像
FROM nvidia/cuda:12.6-runtime-ubuntu20.04

# 安裝必要的工具和依賴項
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    zlib1g \
    zlib1g-dev \
    wget \
    git \
    ffmpeg \
    curl

# 下載並編譯 NGINX 和 nginx-rtmp-module
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -zxvf nginx-1.21.6.tar.gz && \
    cd nginx-1.21.6 && \
    git clone https://github.com/arut/nginx-rtmp-module.git /tmp/nginx-rtmp-module && \
    ./configure --prefix=/usr/local/nginx --add-module=/tmp/nginx-rtmp-module --with-http_ssl_module && \
    make && \
    make install

# 複製 nginx 配置文件
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# 複製 RTMP stat 樣式表
COPY stat.xsl /usr/local/nginx/html/stat.xsl

# 創建必要的目錄
RUN mkdir -p /tmp/hls

# 暴露端口
EXPOSE 1935 80

# 啟動 NGINX
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]