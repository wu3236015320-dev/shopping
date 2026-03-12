# 项目文档总览

本目录集中存放项目相关文档，便于查阅和毕设整理。

---

## 文档列表

| 文档 | 说明 |
|------|------|
| [部署说明.md](./部署说明.md) | 从零在本机运行项目：MySQL、JDK、建库、启动步骤及常见问题 |
| [代码检查与设计优化建议.md](./代码检查与设计优化建议.md) | 已修复的 Bug、毕设规范化改动说明、以及后续可选的优化建议 |

---

## 项目结构说明（哪些是“有用”的）

- **src/** — Java 源码与配置（`config/`、`config.properties`、`log4j.properties`、`com.hjp.shop` 包）
- **WebRoot/** — Web 根目录：页面模板（admin、user、product、order 等）、静态资源（**css/theme.css** 为统一主题）、**img/placeholder.svg** 为商品缺图占位，报表图由系统生成在 img/report/
- **db/** — 数据库脚本 `shopping.sql`
- **docs/** — 本目录，所有文档集中在此
- **启动项目.bat**、**setup_java_env.ps1** — 启动与环境配置脚本

以下目录由 IDE 或编译自动生成，**可忽略**（不必提交到版本库，也不影响运行）：

- **bin/** — Eclipse 编译输出
- **WebRoot/WEB-INF/classes/** — 编译后的 class 文件（若存在）

若发现根目录或其它位置有多余的安装包、临时文件等，可自行删除，保持项目根目录干净即可。
