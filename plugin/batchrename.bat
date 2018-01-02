@echo off & setlocal enabledelayedexpansion

echo 正在清理缓存……
if exist *. del *. 
if exist *temp*.* del *temp*.* 
if exist *.json del *.json 
if exist *.ocd del *.ocd 
if exist *.dll del *.dll 
if exist *.exe del *.exe 
if exist zh*.txt del zh*.txt
if exist ?.txt del ?.txt

for /f %%i in ('dir /s *.jpg^|find /i "个文件"') do set picturenum=%%i

echo 本次下载完毕，共下载%picturenum%个文件，即将打开%cd%……
start %cd%

:batchrename
echo 简化翻译完毕，正在重命名，请稍后……
>%temp%\renametemp.txt echo,
>>%temp%\renametemp.txt type titleactress.txt
set n=1
for /f "delims=" %%a in ('dir /b *.jpg') do (
    set skip=skip=!n!
    call :changename "!skip!" "%%a"
    set /a n+=1
)
goto :eof

:changename
for /f "%~1 delims=" %%a in (%temp%\renametemp.txt) do (
    ren "%~2" "%%a.jpg"
    goto :eof
)



exit