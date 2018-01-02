title AVCoverScraper v1.0.1

@echo off & setlocal enabledelayedexpansion
rem 默认值
set web=1
set begin=1
set end=999
set length=3
for /f "delims=" %%i in ("%cd%") do set folder=%%~ni
set series=%folder%
set translate=1
set sample=1

rem 录入下载信息
set /p series=请键入番号前缀(默认为当前文件夹名%folder%)：
set /p begin=请输入起始序号(默认为%begin%)：
set /p end=请输入结束序号(默认为%end%)：
set /p length=请键入识别码后缀长度(默认为3位)：
set /p web=请选择数据源网站(1:javbus;2:dmm;3:avmoo;4:aventertainments;5:aventertainments(旧)默认为1)：
set /p sample=是否下载样图(默认为1:是)

echo 正在检查本地文件，请稍后……
if exist *.jpg (
for /f %%i in ('dir /s *.jpg^|find /i "个文件"') do set picturenum=%%i
choice /c yn  /t 2 /d y /m 文件夹内发现%picturenum%张图片，继续运行将删除所有图片，是否继续 
if errorlevel 2 goto main
if errorlevel 1 del *.jpg
)

:main

for /l %%a in (%begin% 1 %end%) do (

set a=0000%%a

rem 下载javbus网页源代码
curl -k -i -s -x 127.0.0.1:1080 -# -C - -o %series%-!a:~-%length%!.txt https://www.javbus.com/%series%-!a:~-%length%!
rem 转码原始网页获得待处理文件temp.txt
iconv.exe -c -f UTF-8 -t GBK %series%-!a:~-%length%!.txt > temp.txt
del %series%-!a:~-%length%!.txt

echo 提示：正在下载%series%-!a:~-%length%!封面及样图（%%a/%end%），请稍后……

grep "var img" temp.txt >covertemp.bat

rem 处理得到封面下载地址
sed -i "s/	var img = '/curl -k -x 127.0.0.1:1080 -# -o %series%-!a:~-%length%!.jpg /g" covertemp.bat
sed -i "s/'//g" covertemp.bat
rem 用for替换sed很难替换的分号
for /f "delims=" %%b in (covertemp.bat) do (
set aa=%%b
set aa=!aa:^;=!
echo !aa!>cover.bat)

rem 下载封面

if %web%==1 call cover.bat

if %web%==2 (curl -# -C - -o %series%-!a:~-%length%!.jpg http://pics.dmm.co.jp/mono/movie/adult/%add%%series%!a:~-%length%!/%add%%series%!a:~-%length%!pl.jpg)

if %web%==3 (curl -x 127.0.0.1:1080 -k -s -C - -o %series%-!a:~-%length%!.jpg https://jp.netcdn.space/digital/video/%add%%series%!a:~-%length%!/%add%%series%%avmoo%!a:~-%length%!pl.jpg)

if %web%==4 (curl -x 127.0.0.1:1080 -s -C - -o %series%-!a:~-%length%!.jpg http://imgs.aventertainments.com/new/bigcover/%add%%series%^-!a:~-%length%!.jpg)

if %web%==5 (curl -x 127.0.0.1:1080 -s -C - -o %series%-!a:~-%length%!.jpg http://imgs.aventertainments.com/archive/bigcover/%add%%series%^-!a:~-%length%!.jpg)

rem echo 正在下载%series%-!a:~-%length%!样图
if %sample%==1 (
if not exist %cd%\%series%-!a:~-%length%! md %cd%\%series%-!a:~-%length%!
curl -x 127.0.0.1:1080 -k -L -s -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-1.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-1.jpg -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-2.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-2.jpg  -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-3.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-3.jpg -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-4.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-4.jpg  -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-5.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-5.jpg  -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-6.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-6.jpg  -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-7.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-7.jpg  -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-8.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-8.jpg -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-9.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-9.jpg  -o %cd%\%series%^-!a:~-%length%!\%series%^-!a:~-%length%!^-10.jpg https://pics.dmm.co.jp/digital/video/%series%00!a:~-%length%!/%series%00!a:~-%length%!jp-10.jpg
)


rem 获取标题
grep ^<title^>  temp.txt >titletemp.txt
sed -i "/404 Page Not Found/d"  titletemp.txt
sed -i "s#<title>##g" titletemp.txt 
sed -i "s#JavBus##g" titletemp.txt
sed -i "s#</title>##g" titletemp.txt
sed -i "s# - ##g" titletemp.txt
sed -i "s#<\t##g" titletemp.txt
type titletemp.txt>>title.txt

rem 获取演员信息
grep star-name temp.txt >actresstemp.txt
grep javbus temp.txt |grep star >>actresstemp.txt
sed -i "s#>#\n#g" actresstemp.txt
grep ^<^/a actresstemp.txt >actresstemp1.txt
sed -i "s#</a##g" actresstemp1.txt
sed -i "s#<！##g" actresstemp1.txt
sed -i "s#<\t##g" actresstemp1.txt
rem 去除重复行并输出至actresstemp3.txt
sort actresstemp1.txt | uniq >actresstemp3.txt
rem 追加至列表
paste -s actresstemp3.txt >>actress.txt

rem 获取发行日期
grep 發行日期  temp.txt >datetemp2.txt
rem 删除奇数行
sed "1~2d" datetemp2.txt >datetemp.txt
sed -i "s#>#\n#g" datetemp.txt
sed -i "s#</p##g" datetemp.txt
grep "-" datetemp.txt >>date.txt

rem 获取关键词
grep keywords temp.txt >keywordstemp.txt
sed -i "s#\"#\n#g" keywordstemp.txt
grep , keywordstemp.txt >>keywords.txt
sed -i "s#,# #g" keywords.txt
sed -i "s#<\t##g" keywords.txt
sed -i "s#%series%-!a:~-%length%!##i" keywords.txt

rem 制作商
grep 製作商 temp.txt >makertemp.txt
sed -i "s#>#\n#g" makertemp.txt
grep ^<^/a makertemp.txt >>maker.txt
sed -i "s#</a##g" maker.txt


rem 清理缓存
if exist *. del *.
)

echo %series%封面下载完毕，正在合并信息，请稍后……
paste -d@ title.txt actress.txt date.txt keywords.txt maker.txt>titleactresstemp.txt
sed -i "s#	##g" titleactresstemp.txt
sed -i "s#！# #g" titleactresstemp.txt
rem sed -i "s#@*$##g" titleactresstemp.txt
rem sed -i "s#@@#@#g" titleactresstemp.txt
rem sed -i "s#?##g" titleactresstemp.txt
rem sed -i "s#*##g" titleactresstemp.txt
rem sed -i "s#/# #g" titleactresstemp.txt
rem sed -i "s#:# #g" titleactresstemp.txt
rem sed -i "s#。# #g" titleactresstemp.txt

rem 清理缓存
if exist actress.txt del actress.txt
if exist date.txt del date.txt
if exist keywords.txt del keywords.txt
if exist maker.txt del maker.txt
if exist title.txt del title.txt
if exist cover.bat del cover.bat

if exist D:\Programs\AVCoverScraper\plugin\translate.bat (xcopy /Y /V /D /Q D:\Programs\AVCoverScraper\plugin\translate.bat
) else (
curl -k -# -O -C - https://raw.githubusercontent.com/liuzj288/AVCoverScraper/master/translate.bat
)
call translate.bat

:end
good bye

pause
exit
