@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "JAVA_HOME=C:\Program Files\AdoptOpenJDK\jdk-8.0.292.10-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"

title 编译项目
echo.
echo ========== 编译项目（生成 bin 目录供 一键启动 使用）==========
echo.

if not exist "bin" mkdir bin
copy /y "src\config.properties" "bin\" >nul
echo 已复制 config.properties 到 bin
echo.

set "CP=WebRoot\WEB-INF\lib"
for %%f in (WebRoot\WEB-INF\lib\*.jar) do set "CP=!CP!;%%f"

dir /s /b src\*.java 2>nul > sources.txt
if not exist sources.txt (
    echo 未找到 src 下的 java 文件。
    pause
    exit /b 1
)
echo 正在编译...
javac -encoding UTF-8 -cp "%CP%" -d bin @sources.txt
del sources.txt 2>nul

if exist "bin\config\ShopConfig.class" (
    echo.
    echo √ 编译成功。可运行「一键启动.bat」启动网站。
) else (
    echo.
    echo × 编译可能失败，请检查上方是否有报错，并确认 JAVA_HOME 为本机 JDK 路径。
)
echo.
pause
