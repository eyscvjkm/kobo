#!/bin/sh

# 自定义路径
VM_PATH="BRnLgPZ8PvYSmQH"
VL_PATH="wIqVBMMI33aT2UR"

# 自定义 xray_uuid (保持和 Dockerfile 文件里的一致)
XUID_1=${XUUID_1:-"d0dc1f7c-70f4-47a4-88d3-75e495ef1d35"}
XUID_2=${XUUID_2:-"735c77a0-1da4-443b-822b-1c809a8f0f5e"}
XUID_3=${XUUID_3:-"7057181c-fdd4-4f6f-a9e9-b88e47376873"}

# 自定义 v2ray_uuid (保持和 Dockerfile 文件里的一致)
VUID_1=${VUUID_1:-"2d5a7946-ced5-4665-bb1f-b2fa8c684b2c"}
VUID_2=${VUUID_2:-"94a256ec-06d0-436d-9545-6b4f6cab4dcf"}
VUID_3=${VUUID_3:-"f1c5abc1-730d-4d6c-95f4-8f142470f5ba"}

# 端口默认不要修改
PORT=${PORT:-8080}

# 替换到系统配置（端口、路径）
sed -i "s/\$PORT/$PORT/g" /etc/caddy/Caddyfile
sed -i "s|VMESS_PATH|/$VM_PATH|g" /etc/caddy/Caddyfile
sed -i "s|VLESS_PATH|/$VL_PATH|g" /etc/caddy/Caddyfile

# 替换到 xray.json 配置中的（UUID）
sed -i "s/\$XUUID_1/$XUID_1/g" /xray.json
sed -i "s/\$XUUID_2/$XUID_2/g" /xray.json
sed -i "s/\$XUUID_3/$XUID_3/g" /xray.json

# 替换到 xray.json 配置中的（UUID）
sed -i "s/\$VUUID_1/$VUID_1/g" /xray.json
sed -i "s/\$VUUID_2/$VUID_2/g" /xray.json
sed -i "s/\$VUUID_3/$VUID_3/g" /xray.json

# 替换到 xray.json 配置中的（路径）
sed -i "s|VMESS_PATH|/$VM_PATH|g" /xray.json
sed -i "s|VLESS_PATH|/$VL_PATH|g" /xray.json

# 启动后台服务
tor &
/xray -config /xray.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &

# 进程守护
wait -n
exit $?
