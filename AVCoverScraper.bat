title AVCoverScraper v1.0.1

@echo off & setlocal enabledelayedexpansion
rem Ĭ��ֵ
set web=1
set begin=1
set end=999
set length=3
for /f "delims=" %%i in ("%cd%") do set folder=%%~ni
set series=%folder%
set translate=1

rem ¼��������Ϣ
set /p series=����뷬��ǰ׺(Ĭ��Ϊ��ǰ�ļ�����%folder%)��
set /p begin=��������ʼ���(Ĭ��Ϊ%begin%)��
set /p end=������������(Ĭ��Ϊ%end%)��
set /p length=�����ʶ�����׺����(Ĭ��Ϊ3λ)��
set /p web=��ѡ������Դ��վ(1:javbus;2:dmm;3:avmoo;4:aventertainments;5:aventertainments(��)Ĭ��Ϊ1)��
set /p translate=�Ƿ������Զ�����(Ĭ��Ϊ1:����)

echo ���ڼ�鱾���ļ������Ժ󡭡�
if exist *.jpg for /f %%i in ('dir /s *.jpg^|find /i "���ļ�"') do set picturenum=%%i
if exist *.jpg choice /c yn  /t 2 /d y /m �ļ����ڷ���%picturenum%��ͼƬ���������н�ɾ������ͼƬ���Ƿ���� 
if errorlevel 2 goto end
if errorlevel 1 goto clean


:clean
if exist *.jpg del *.jpg 

for /l %%a in (%begin% 1 %end%) do (

set a=0000%%a

rem ����javbus��ҳԴ����
curl -k -i -s -x 127.0.0.1:1080 -# -C - -o %series%-!a:~-%length%!.txt https://www.javbus.com/%series%-!a:~-%length%!
rem ת��ԭʼ��ҳ��ô������ļ�temp.txt
iconv.exe -c -f UTF-8 -t GBK %series%-!a:~-%length%!.txt > temp.txt
del %series%-!a:~-%length%!.txt

echo ��ʾ����������%series%-!a:~-%length%!���棨%%a/%end%�������Ժ󡭡�

grep "var img" temp.txt >covertemp.bat

rem ����õ��������ص�ַ
sed -i "s/	var img = '/curl -k -x 127.0.0.1:1080 -# -o %series%-!a:~-%length%!.jpg /g" covertemp.bat
sed -i "s/'//g" covertemp.bat
rem ��for�滻sed�����滻�ķֺ�
for /f "delims=" %%b in (covertemp.bat) do (
set aa=%%b
set aa=!aa:^;=!
echo !aa!>cover.bat)

rem ���ط���

if %web%==1 call cover.bat

if %web%==2 (curl -# -C - -o %series%-!a:~-%length%!.jpg http://pics.dmm.co.jp/mono/movie/adult/%add%%series%!a:~-%length%!/%add%%series%!a:~-%length%!pl.jpg)

if %web%==3 (curl -x 127.0.0.1:1080 -k -s -C - -o %series%-!a:~-%length%!.jpg https://jp.netcdn.space/digital/video/%add%%series%!a:~-%length%!/%add%%series%%avmoo%!a:~-%length%!pl.jpg)

if %web%==4 (curl -x 127.0.0.1:1080 -s -C - -o %series%-!a:~-%length%!.jpg http://imgs.aventertainments.com/new/bigcover/%add%%series%^-!a:~-%length%!.jpg)

if %web%==5 (curl -x 127.0.0.1:1080 -s -C - -o %series%-!a:~-%length%!.jpg http://imgs.aventertainments.com/archive/bigcover/%add%%series%^-!a:~-%length%!.jpg)


rem ��ȡ����
grep ^<title^>  temp.txt >titletemp.txt
sed -i "/404 Page Not Found/d"  titletemp.txt
sed -i "s#<title>##g" titletemp.txt 
sed -i "s#JavBus##g" titletemp.txt
sed -i "s#</title>##g" titletemp.txt
sed -i "s# - ##g" titletemp.txt
sed -i "s#<\t##g" titletemp.txt
type titletemp.txt>>title.txt

rem ��ȡ��Ա��Ϣ
grep star-name temp.txt >actresstemp.txt
grep javbus temp.txt |grep star >>actresstemp.txt
sed -i "s#>#\n#g" actresstemp.txt
grep ^<^/a actresstemp.txt >actresstemp1.txt
sed -i "s#</a##g" actresstemp1.txt
sed -i "s#<��##g" actresstemp1.txt
sed -i "s#<\t##g" actresstemp1.txt
rem ȥ���ظ��в������actresstemp3.txt
sort actresstemp1.txt | uniq >actresstemp3.txt
rem ׷�����б�
paste -s actresstemp3.txt >>actress.txt

rem ��ȡ��������
grep �l������  temp.txt >datetemp2.txt
rem ɾ��������
sed "1~2d" datetemp2.txt >datetemp.txt
sed -i "s#>#\n#g" datetemp.txt
sed -i "s#</p##g" datetemp.txt
grep "-" datetemp.txt >>date.txt

rem ��ȡ�ؼ���
grep keywords temp.txt >keywordstemp.txt
sed -i "s#\"#\n#g" keywordstemp.txt
grep , keywordstemp.txt >>keywords.txt
sed -i "s#,# #g" keywords.txt
sed -i "s#<\t##g" keywords.txt
sed -i "s#%series%-!a:~-%length%!##i" keywords.txt

rem ������
grep �u���� temp.txt >makertemp.txt
sed -i "s#>#\n#g" makertemp.txt
grep ^<^/a makertemp.txt >>maker.txt
sed -i "s#</a##g" maker.txt


rem ������
if exist *. del *.
)

echo %series%����������ϣ����ںϲ���Ϣ�����Ժ󡭡�
paste -d@ title.txt actress.txt date.txt keywords.txt maker.txt>titleactresstemp.txt
sed -i "s#	##g" titleactresstemp.txt
sed -i "s#@*$##g" titleactresstemp.txt
sed -i "s#@@#@#g" titleactresstemp.txt
sed -i "s#?##g" titleactresstemp.txt
sed -i "s#*##g" titleactresstemp.txt
sed -i "s#/# #g" titleactresstemp.txt
sed -i "s#:# #g" titleactresstemp.txt
sed -i "s#��# #g" titleactresstemp.txt

if exist D:\Programs\AVCoverScraper\translate.bat (call D:\Programs\AVCoverScraper\translate.bat
) else (
curl -k -# -O -C - https://raw.githubusercontent.com/liuzj288/AVCoverScraper/master/translate.bat
call translate.bat
)

if exist D:\Programs\AVCoverScraper\batchrename.bat (call D:\Programs\AVCoverScraper\batchrename.bat
) else (
curl -k -# -O -C - https://raw.githubusercontent.com/liuzj288/AVCoverScraper/master/batchrename.bat
call batchrename.bat
)

pause
exit
