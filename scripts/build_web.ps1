# 本地构建 Web 版到 build/web（可用于本地预览或调试）
# 用法：
#   ./scripts/build_web.ps1            # 构建到 build/web
#   ./scripts/build_web.ps1 -Run       # 构建后启动本地服务器
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

param([switch]$Run)

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw "未找到 flutter 命令。"
}

Write-Host "[1/2] flutter pub get..." -ForegroundColor Cyan
flutter pub get

Write-Host "[2/2] flutter build web --release..." -ForegroundColor Cyan
flutter build web --release --base-href=/

Write-Host "构建完成 ✔ 产物在 build/web" -ForegroundColor Green

if ($Run) {
    Write-Host "启动本地预览 http://localhost:5000 ..." -ForegroundColor Cyan
    if (Get-Command python -ErrorAction SilentlyContinue) {
        python -m http.server 5000 --directory build/web
    } elseif (Get-Command npx -ErrorAction SilentlyContinue) {
        npx serve -s -l 5000 build/web
    } else {
        Write-Host "请自行用静态服务器托管 build/web（如 npx serve / python -m http.server）。" -ForegroundColor Yellow
    }
}