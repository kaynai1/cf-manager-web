# Cloudflare 管理器 —— Web 版（Docker 部署）

> 这是一个**独立工程**，只做 **Web 版 / Docker 部署**。Windows 桌面应用在
> 另一个独立工程 `cloudflare-manager-windows` 中。本目录可单独拷贝、单独构建、单独部署。

一个把 **Cloudflare 免费功能**集中管理的 **Web 应用**：多账号、域名、DNS、设置、Workers、
KV、D1、R2、Pages、Queues、Workers AI、Turnstile、Email Routing、API 令牌等。iOS 风格界面，
凭证由 **WebCrypto** 加密后存在于**每位用户的浏览器本地**，服务端不存储任何密钥。

---

## 一、一键部署（Docker）

### 环境要求
- 安装 Docker（Windows 用 Docker Desktop；Linux 用 docker engine + compose 插件）

### 启动
```bash
docker compose up -d          # 构建并后台启动
docker compose up -d --build  # 改代码后重新构建
```

浏览器访问：**http://localhost:8080**

> 需要公网 / 局域网访问时，把 `docker-compose.yml` 里的 `ports: "8080:80"` 改成想要的
> 宿主机端口（如 `"80:80"` 或 `"9000:80"`）。

### 常用命令
```bash
docker compose logs -f        # 查看日志
docker compose down           # 停止（保留镜像）
docker compose down --rmi all # 停止并删除镜像
docker images                 # 查看镜像 cloudflare-manager
```

## 二、本地构建 / 预览（可选）

```powershell
# 构建到 build/web
./scripts/build_web.ps1

# 构建并启动本地预览 http://localhost:5000
./scripts/build_web.ps1 -Run
```

或直接 Flutter：
```bash
flutter pub get
flutter build web --release
```

## 三、部署到子路径（例如 /cloudflare/）

若希望通过 `https://你的域名/cloudflare/` 访问，构建时指定 base-href：
```bash
docker compose build --build-arg FLUTTER_BASE_HREF=/cloudflare/
# 并同步在反向代理（如 nginx / caddy）中把 /cloudflare/ 代理到容器 8080
```

## 四、功能清单

- 账号级：多账号、API Token / Global API Key、API 令牌管理、成员、Turnstile、Access
- 域名级：DNS、DNSSEC、设置引擎（56 项）、缓存清除、分析、Page Rules、安全、Email Routing
- 开发者平台：Workers、KV、D1、R2、Pages、Queues、AI Gateway、Vectorize、Durable Objects
- 启动登录门禁

## 五、安全说明（重要）

- **不要**把真实 API Token / Global API Key 写进源码（会随 Web 打包可反编译提取）。
  `lib/src/defaults.dart` 默认为空，请在 App 内手动添加账号。
- Web 端凭证由 WebCrypto 加密后存入**浏览器本地**，每位用户各有其归，服务端/容器**不保存**任何凭证。
- 应用启动登录密码为占位示例（`admin` / `admin`），发布前请在 `lib/src/store.dart` 修改。

## 六、目录结构

```
Dockerfile              # 多阶段构建：Flutter 官方镜像编译 Web → Nginx 静态托管
docker-compose.yml      # 编排，宿主机 8080 -> 容器 80
deploy/nginx.conf       # Nginx：gzip、静态缓存、SPA 回退、安全头
.dockerignore           # 排除非 Web 平台，加速构建
web/                    # Web 平台脚手架（index.html / manifest / icons）
lib/                    # Flutter 应用源码
scripts/build_web.ps1   # 本机构建脚本
```

## 七、许可证

MIT License