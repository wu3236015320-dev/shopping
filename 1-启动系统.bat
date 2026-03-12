@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

title 一键启动 - 购物商城
echo.
echo ========== 一键启动（MySQL + 项目 + 浏览器）==========
echo.

:: 0) 若未编译则提示先运行 编译.bat
if not exist "bin\config\ShopConfig.class" (
    echo [提示] 未检测到编译结果（bin\config\ShopConfig.class）。
    echo        请先双击运行「编译.bat」完成编译后，再运行本脚本。
    echo.
    pause
    exit /b 1
)

:: 释放可能占用 8090 的旧进程（避免旧服务返回 503）
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8090" ^| findstr "LISTENING" 2^>nul') do (
    taskkill /F /PID %%a 2>nul
    timeout /t 2 /nobreak >nul
)

:: 1) 尝试启动 MySQL 服务（常见服务名逐个尝试，已运行则跳过）
echo [1/4] 检查并启动 MySQL 服务...
net start MySQL 2>nul || net start MySQL80 2>nul || net start MySQL96 2>nul || net start MySQL57 2>nul
if %errorlevel% equ 0 (
    echo       MySQL 服务已启动，等待 5 秒以便就绪...
    timeout /t 5 /nobreak >nul
) else (
    echo       MySQL 可能已在运行，或需在「服务」中手动启动。
)
echo.

:: 2) 在新窗口启动 JFinal 项目（保持原 启动项目.bat 的配置）
echo [2/4] 正在启动网站服务（新窗口）...
set "JAVA_HOME=C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "CP=bin;WebRoot\WEB-INF\classes;WebRoot"
for %%f in (WebRoot\WEB-INF\lib\*.jar) do set "CP=!CP!;%%f"

start "购物商城-请勿关闭此窗口" cmd /k "chcp 65001 >nul && set "JAVA_HOME=%JAVA_HOME%" && set "PATH=%JAVA_HOME%\bin;%PATH%" && set "CP=%CP%" && echo 网站运行中，关闭本窗口即停止网站。 && echo. && java -cp "%CP%" config.ShopConfig && pause"
echo       等待服务就绪...
ping 127.0.0.1 -n 1 -w 1000 >nul
timeout /t 10 /nobreak >nul
echo.

:: 3) 打开浏览器
echo [3/4] 打开浏览器...
start "" "http://127.0.0.1:8090/"
echo.
echo [4/4] ========== 完成 ==========
echo 浏览器已打开。若要关闭网站，请关闭「购物商城-请勿关闭此窗口」。
echo.
echo 【重要】若页面显示 503 Service Unavailable：
echo   1. 请先运行一次「编译.bat」，再重新运行本脚本
echo   2. 若已编译仍 503：运行「诊断-503.bat」确认 MySQL；并查看「购物商城-请勿关闭此窗口」是否有红色报错
echo   3. 确认「服务」里 MySQL 为「正在运行」（Win+R 输入 services.msc）
echo.
pause
