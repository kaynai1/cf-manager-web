# syntax=docker/dockerfile:1.4
# ============================================================================
# Cloudflare 管理器 —— Web 版镜像（多阶段构建）
# 独立工程：cloudflare-manager-web
#
# 阶段一：在官方 Flutter 镜像中构建 Web 产物（build/web）
# 阶段二：用 Nginx 提供静态文件
#
# 构建：  docker build -t cloudflare-manager .
# 运行：  docker compose up -d
# ============================================================================

# ---------- 阶段一：Flutter 构建 ----------
FROM ghcr.io/cirruslabs/flutter:stable AS build-web

WORKDIR /app

# 1) 先拷贝 pubspec 以利用 Docker 层缓存，减少重复 pub get
# 注意：不拷贝 pubspec.lock —— 依赖变更时旧 lock 会导致 pub get 失败
COPY pubspec.yaml ./
RUN flutter pub get

# 2) 拷贝源码并启用 Web
COPY lib ./lib
COPY web ./web
COPY assets ./assets

# 若需要固定 baseHref/路径，可通过 build ARG 覆盖
ARG FLUTTER_BASE_HREF=/

# 3) 构建 Web 版（Release）
RUN flutter build web \
    --release \
    --base-href=${FLUTTER_BASE_HREF}

# ---------- 阶段二：Nginx 托管 ----------
FROM nginx:stable-alpine AS runtime

# 拷贝 Web 产物
COPY --from=build-web /app/build/web /usr/share/nginx/html

# 自定义 Nginx 配置（静态缓存 + history 回退）
COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1

CMD ["nginx", "-g", "daemon off;"]