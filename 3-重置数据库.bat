@echo off
chcp 65001 >nul
echo 正在用 db\shopping.sql 重置 shopping 数据库（会重建表并插入 70 条测试商品）...
echo.
cd /d "%~dp0"
"C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe" -u root -proot < db\shopping.sql
if %errorlevel% equ 0 (
    echo.
    echo 执行成功。请重启 启动项目.bat，然后访问 http://127.0.0.1:8090/
    echo 若 MySQL 不在上述路径，请用记事本打开本文件，修改第一行中的 mysql.exe 路径。
) else (
    echo.
    echo 执行失败。请检查：1）MySQL 服务是否启动  2）密码是否为 root  3）路径是否为 MySQL Server 9.6
)
pause
