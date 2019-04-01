@echo off

:: 使用方法
if "%~1" == "" (
echo Hashを求めたいファイルをドラッグ＆ドロップしてください
pause
)

:: 定義
setlocal
set CmdName=CertUtil
set HashMethod=SHA256
set OutputPath=%~dp0\outputHash.txt

for %%a in (%*) do for %%f in (%%a) do call :PrintFileHash "%%~f"
exit /b 0
:PrintFileHash
set Hash=
for /f "usebackq delims=" %%h in (`%CmdName% -hashfile "%~1" %HashMethod% ^| find /v "%HashMethod%" ^| find /v "%CmdName%:"`) do set Hash=%%h
:: ファイルサイズが0だとエラーになるので例外処理
if "%Hash%" == "" if "%~z1" == "0" (
set Hash="ファイルサイズが0です"
) else (
exit /b 0
)

:: 間のスペースを削除
set Hash=%Hash: =%

:: OutputPath(.batファイルと同じ階層)に出力
:: 1ファイル毎に改行
echo ■%~n1%~x1(%HashMethod%)>> "%OutputPath%"
echo %Hash%>> "%OutputPath%"
echo;>> "%OutputPath%"
