FROM alpine:latest

# 自定义 xray_uuid (保持和 start.sh 文件里的一致)
ENV XUUID_1="d0dc1f7c-70f4-47a4-88d3-75e495ef1d35"
ENV XUUID_2="735c77a0-1da4-443b-822b-1c809a8f0f5e"
ENV XUUID_3="7057181c-fdd4-4f6f-a9e9-b88e47376873"

# 自定义 v2ray_uuid (保持和 start.sh 文件里的一致)
ENV VUUID_1="2d5a7946-ced5-4665-bb1f-b2fa8c684b2c"
ENV VUUID_2="94a256ec-06d0-436d-9545-6b4f6cab4dcf"
ENV VUUID_3="f1c5abc1-730d-4d6c-95f4-8f142470f5ba"

# 端口默认不要修改
ENV PORT=8080

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget unzip tzdata && \
    # 下载 Linux 版 Xray 核心
    wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray.zip xray geoip.dat geosite.dat -d / && \
    chmod +x /xray && \
    rm -f /tmp/xray.zip && \
    # 创建目录
    mkdir -p /etc/caddy/ /usr/share/caddy && \
    echo -e "User-agent: *\nDisallow: /" > /usr/share/caddy/robots.txt && \
    rm -rf /var/cache/apk/*

# 将本地文件拷贝到镜像中
COPY web/ /usr/share/caddy/
COPY etc/Caddyfile /etc/caddy/Caddyfile
COPY etc/xray.json /xray.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
