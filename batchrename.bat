@echo off & setlocal enabledelayedexpansion

:batchrename
echo 简化翻译完毕，正在重命名，请稍后……
>%temp%\rename.txt echo,
>>%temp%\rename.txt type titleactress.txt
set n=1
for /f "delims=" %%a in ('dir /b *.jpg') do (
    set skip=skip=!n!
    call :changename "!skip!" "%%a"
    set /a n+=1
)
goto :eof

:changename
for /f "%~1 delims=" %%a in (%temp%\rename.txt) do (
    ren "%~2" "%%a.jpg"
    goto :eof
)

exit