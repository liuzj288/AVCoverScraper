@echo off & setlocal enabledelayedexpansion

rem ����opencc.zip

if exist opencc.exe goto tw2sp

if not exist opencc.exe goto openccdownload

:openccdownload
echo ��������opencc ���Ժ󡭡�
if exist D:\Programs\opencc\opencc.exe (xcopy /Y /V /D /Q D:\Programs\opencc\*.*
) else (
curl -k -# -O -C - https://raw.githubusercontent.com/liuzj288/AVCoverScraper/master/opencc.zip
)

if exist C:\Program Files\Bandizip\Bandizip.exe goto Bandizip

:Bandizip
echo ���ڽ�ѹopencc.zip ���Ժ󡭡�
rem set path=��C:\Program Files\Bandizip��
Bandizip.exe x opencc.zip
Bandizip.exe x -o:D:\Programs\opencc\ opencc.zip
goto tw2sp

:tw2sp
echo ����ʹ��opencc�򻯷��� ���Ժ󡭡�
rem openccֻ���Դ���utf8����
iconv.exe -c -f GBK -t UTF-8 titleactresstemp.txt > titleactresstemputf8.txt
opencc -i titleactresstemputf8.txt -o titleactresstemp.txt -c tw2sp.json
rem ����ϵͳGBK���벻������
iconv.exe -c -f UTF-8 -t GBK titleactresstemp.txt > titleactress.txt

rem ɾ������
if exist *.json del *.json 
if exist *.ocd del *.ocd 
if exist *.dll del *.dll 
if exist *.exe del *.exe 
if exist zh*.txt del zh*.txt

