@echo off
chcp 65001 >nul
echo.
echo ========== 导出当前数据库到 SQL 文件 ==========
echo.
echo 本脚本会将当前 MySQL 数据库中的所有数据导出到 db\shopping-export.sql
echo 用于换电脑部署时恢复完整数据（包含你添加的商品、订单、用户等）
echo.

:: 设置 MySQL 路径和密码（根据实际情况修改）
set "MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 9.6\bin"
set "MYSQL_USER=root"
set "MYSQL_PASS=root"
set "DB_NAME=shopping"
set "EXPORT_FILE=db\shopping-export.sql"

echo [1/3] 检查 MySQL 路径...
if not exist "%MYSQL_PATH%\mysqldump.exe" (
    echo [错误] 未找到 mysqldump.exe，请修改脚本中的 MYSQL_PATH 路径
    echo 默认路径: %MYSQL_PATH%
    pause
    exit /b 1
)

echo [2/3] 开始导出数据库...
echo       导出文件: %EXPORT_FILE%
echo       数据库: %DB_NAME%
echo.

"%MYSQL_PATH%\mysqldump.exe" -u%MYSQL_USER% -p%MYSQL_PASS% --databases %DB_NAME% --complete-insert --extended-insert --disable-keys --add-drop-table --create-options --quick --routines --triggers > "%EXPORT_FILE%"

if %errorlevel% neq 0 (
    echo [错误] 导出失败！请检查:
    echo   1. MySQL 服务是否运行
    echo   2. 用户名密码是否正确
    echo   3. 数据库 %DB_NAME% 是否存在
    pause
    exit /b 1
)

echo [3/3] 导出完成！
echo.
echo ========================================
echo 导出文件: %EXPORT_FILE%
echo 文件大小:
for %%I in ("%EXPORT_FILE%") do echo          %%~zI 字节
echo ========================================
echo.
echo 使用说明:
echo   1. 在新电脑执行本脚本，生成 shopping-export.sql
echo   2. 将 shopping-export.sql 复制到新电脑
echo   3. 在新电脑执行: mysql -u root -p shopping ^< shopping-export.sql
echo.
echo [提示] shopping-export.sql 包含所有表结构和数据，
echo        比原始的 shopping.sql 更完整！
echo.
pause
