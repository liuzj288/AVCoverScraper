@echo off & setlocal enabledelayedexpansion

rem 下载opencc.zip

if exist opencc.exe goto tw2sp

if not exist opencc.exe goto openccdownload

:openccdownload

if exist D:\Programs\AVCoverScraper\opencc\opencc.exe (
echo 正在复制opencc到%cd% 请稍后……
xcopy /Y /V /D /Q D:\Programs\AVCoverScraper\opencc\*.* 
) else (
echo 正在从github下载opencc.zip到%cd%
curl -k -# -O -C - https://raw.githubusercontent.com/liuzj288/AVCoverScraper/master/opencc.zip
:Bandizip
rem set path=“C:\Program Files\Bandizip”
echo 正在解压opencc.zip到%cd% 请稍后……
Bandizip.exe x opencc.zip
rem Bandizip.exe x -o:D:\Programs\AVCoverScraper\opencc\ opencc.zip
goto tw2sp
)

:tw2sp
echo 正在使用opencc简化翻译 请稍后……
rem opencc只可以处理utf8编码
iconv.exe -c -f GBK -t UTF-8 titleactresstemp.txt > titleactresstemputf8.txt
opencc -i titleactresstemputf8.txt -o titleactresstemp.txt -c tw2sp.json
rem 操作系统GBK编码不会乱码
iconv.exe -c -f UTF-8 -t GBK titleactresstemp.txt > titleactress.txt

rem 删除缓存
if exist *.json del *.json 
if exist *.ocd del *.ocd 
if exist *.dll del *.dll 
if exist *.exe del *.exe 
if exist zh*.txt del zh*.txt
if exist ?.txt del ?.txt


if exist D:\Programs\AVCoverScraper\plugin\batchrename.bat (xcopy /Y /V /D /Q D:\Programs\AVCoverScraper\plugin\batchrename.bat
) else (
curl -k -# -O -C - https://raw.githubusercontent.com/liuzj288/AVCoverScraper/master/batchrename.bat
)
call batchrename.bat



exit