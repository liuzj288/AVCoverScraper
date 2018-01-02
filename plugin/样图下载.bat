set /p series=请键入番号前缀(默认为当前文件夹名%folder%)：
set /p num=请键入番号后缀数字：
rem set /p length=请键入识别码后缀长度(默认为3位)：
md %cd%\%series%-%num%
for /l %%b in (1 1 10) do (
curl -x 127.0.0.1:1080 -k -# -C - -o %cd%\%series%-%num%\%series%-%num%-%%b.jpg https://pics.dmm.co.jp/digital/video/%series%00%num%/%series%00%num%jp-%%b.jpg
)