# 从 Picsum Photos 批量下载商品占位图到 WebRoot/img/product/
# 用法：在项目根目录执行  .\scripts\download-product-images.ps1
# 或进入 scripts 目录执行  .\download-product-images.ps1

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = (Get-Item $scriptDir).Parent.FullName
$imgDir = Join-Path $projectRoot "WebRoot\img\product"

if (-not (Test-Path $imgDir)) {
    New-Item -ItemType Directory -Path $imgDir -Force | Out-Null
    Write-Host "已创建目录: $imgDir"
}

$count = 70
$baseUrl = "https://picsum.photos/seed"

Write-Host "正在下载 $count 张占位图到 $imgDir ..."
for ($id = 1; $id -le $count; $id++) {
    $url = "$baseUrl/$id/400/400"
    $outPath = Join-Path $imgDir "$id.jpg"
    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing
        Write-Host "  $id.jpg 完成"
    } catch {
        Write-Warning "  $id.jpg 失败: $_"
    }
}
Write-Host "完成。请刷新前台页面查看商品图片。"
