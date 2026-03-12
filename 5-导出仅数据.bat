@echo off
chcp 65001 >nul
echo.
echo ========== 导出当前数据库数据（仅INSERT语句） ==========
echo.
echo 说明：
echo   本脚本导出当前数据库中的所有数据（商品、订单、用户等）
echo   不包含表结构，假设新电脑已用 shopping.sql 初始化过表结构
echo   适合：换电脑时迁移业务数据
echo.

:: 设置 MySQL 路径和密码（根据实际情况修改）
set "MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 9.6\bin"
set "MYSQL_USER=root"
set "MYSQL_PASS=root"
set "DB_NAME=shopping"
set "EXPORT_FILE=db\shopping-data-export.sql"

echo [1/4] 检查 MySQL 路径...
if not exist "%MYSQL_PATH%\mysqldump.exe" (
    echo [错误] 未找到 mysqldump.exe
    echo 请修改脚本第9行的 MYSQL_PATH 为你的 MySQL 安装路径
    echo 例如：C:\Program Files\MySQL\MySQL Server 8.0\bin
    pause
    exit /b 1
)

echo [2/4] 正在导出数据...
echo       导出文件: %EXPORT_FILE%
echo.

:: 导出数据（不包含表结构）
"%MYSQL_PATH%\mysqldump.exe" -u%MYSQL_USER% -p%MYSQL_PASS% --no-create-info --complete-insert --extended-insert --disable-keys --quick %DB_NAME% > "%EXPORT_FILE%"

if %errorlevel% neq 0 (
    echo [错误] 导出失败！请检查:
    echo   1. MySQL 服务是否运行（services.msc 查看）
    echo   2. 用户名密码是否正确（默认 root/root）
    echo   3. 数据库 %DB_NAME% 是否存在
    pause
    exit /b 1
)

echo [3/4] 添加注释说明...
echo -- 数据导出文件 > db\shopping-data-export-temp.sql
echo -- 生成时间: %date% %time% >> db\shopping-data-export-temp.sql
echo -- 导出命令: mysqldump --no-create-info >> db\shopping-data-export-temp.sql
echo. >> db\shopping-data-export-temp.sql
type "%EXPORT_FILE%" >> db\shopping-data-export-temp.sql
del "%EXPORT_FILE%"
move db\shopping-data-export-temp.sql "%EXPORT_FILE%"

echo [4/4] 导出完成！
echo.
echo ========================================
echo 导出文件: %EXPORT_FILE%
for %%I in ("%EXPORT_FILE%") do echo 文件大小: %%~zI 字节
echo ========================================
echo.
echo 【换电脑部署步骤】
echo 1. 在新电脑执行【更新数据库-完整重置.bat】（创建表结构+初始数据）
echo 2. 复制本文件到 db\ 目录
echo 3. 执行命令导入数据:
echo    mysql -u root -p shopping ^< db\shopping-data-export.sql
echo.
echo 【警告】
echo    这会覆盖新电脑上 shopping.sql 的初始数据！
echo    如需保留初始数据，请先备份！
echo.
pause
