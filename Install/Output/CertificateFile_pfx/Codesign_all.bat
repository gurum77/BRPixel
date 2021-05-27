rem %1 : path for exe file and dll file

rem code sign start *.dll
signtool.exe sign /a /v  /f HanGil_CodeSign.pfx /p aa123123 /t http://timestamp.verisign.com/scripts/timestamp.dll %1\*.dll

rem code sign start *.exe
signtool.exe sign /a /v  /f HanGil_CodeSign.pfx /p aa123123 /t http://timestamp.verisign.com/scripts/timestamp.dll %1\*.exe
