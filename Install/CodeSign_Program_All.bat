REM codesign program
pushd CertificateFile_pfx
call Codesign_all.bat ..\..\..\BRPixel_bin\Windows
popd
