git clone https://github.com/aerocyber/sitemarker
cp windows-installer.iss sitemarker
explorer.exe sitemarker/
pause
mkdir ../../../build/windows/installer -p
mv sitemarker/build/windows/installer/* ../../../build/windows/installer
