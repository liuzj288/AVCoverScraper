set /p series=����뷬��ǰ׺(Ĭ��Ϊ��ǰ�ļ�����%folder%)��
set /p num=����뷬�ź�׺���֣�
rem set /p length=�����ʶ�����׺����(Ĭ��Ϊ3λ)��
md %cd%\%series%-%num%
for /l %%b in (1 1 10) do (
curl -x 127.0.0.1:1080 -k -# -C - -o %cd%\%series%-%num%\%series%-%num%-%%b.jpg https://pics.dmm.co.jp/digital/video/%series%00%num%/%series%00%num%jp-%%b.jpg
)