@echo off
chcp 65001 >nul
cd /d "%~dp0"
title 503 诊断 - 检查 MySQL 与配置
echo.
echo ========== 503 诊断：检查 MySQL 能否连接 ==========
echo.

:: 使用与 更新数据库-完整重置.bat 相同的 mysql 路径，若你改过那个 bat 请同步改下面这行
set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe"
set "MYSQL_PWD=root"

echo [1] 测试 MySQL 连接与 shopping 库...
"%MYSQL_EXE%" -u root -p%MYSQL_PWD% -e "USE shopping; SELECT COUNT(*) AS product_count FROM tbl_product;" 2>nul
if %errorlevel% neq 0 (
    echo.
    echo      × 连接失败。请检查：
    echo        - MySQL 服务是否已启动（services.msc 中查看）
    echo        - 本文件中 MYSQL_EXE 路径是否为你本机的 mysql.exe 路径
    echo        - 上面 MYSQL_PWD=root 是否与你的 MySQL 密码一致（若不一致请用记事本打开本文件修改）
    echo.
    goto :end
)
echo      √ MySQL 连接正常，shopping 库存在。
echo.

echo [2] 请确认以下两项一致，否则会出现 503：
echo      - 你的 MySQL root 密码
echo      - 项目里的 jdbc.password（在下面两个文件里都要一致）：
echo        src\config.properties
echo        WebRoot\WEB-INF\classes\config.properties
echo        当前配置的密码为：%MYSQL_PWD%
echo.

echo [3] 若仍 503，请查看运行网站时弹出的「购物商城-请勿关闭此窗口」窗口：
echo      - 若有红色报错（如 Access denied、Could not create connection、Communications link failure），
echo        多半是 MySQL 密码或地址不对，请把两个 config.properties 里的 jdbc.password 改成你的 MySQL 密码。
echo      - 若是「找不到或无法加载主类」，请用 Eclipse 打开项目后菜单 项目 - 构建项目，再运行 一键启动.bat。
echo.
:end
echo ========== 结束 ==========
pause
