@echo off & setlocal enabledelayedexpansion

echo ���������桭��
if exist *. del *. 
if exist *temp*.* del *temp*.* 
if exist *.json del *.json 
if exist *.ocd del *.ocd 
if exist *.dll del *.dll 
if exist *.exe del *.exe 
if exist zh*.txt del zh*.txt
if exist ?.txt del ?.txt

for /f %%i in ('dir /s *.jpg^|find /i "���ļ�"') do set picturenum=%%i

echo ����������ϣ�������%picturenum%���ļ���������%cd%����
start %cd%

:batchrename
echo �򻯷�����ϣ����������������Ժ󡭡�
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