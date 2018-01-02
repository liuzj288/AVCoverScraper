@echo off 

echo 正在清理缓存……
if exist *temp?.* del *temp?.* 
if exist *.json del *.json 
if exist *.ocd del *.ocd 
if exist *.dll del *.dll 
if exist *.exe del *.exe 
if exist zh*.txt del zh*.txt
if exist ?.txt del ?.txt

exit