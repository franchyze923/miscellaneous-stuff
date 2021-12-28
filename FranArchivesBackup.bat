ECHO Begin FranArchives Backup: > "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1
robocopy \\xxx.xxx.x.xxx\FranArchives\ X:\ /MIR /FFT /R:0 /MT:4 /XA:SH /XD \\xxx.xxx.x.xxx\FranArchives\Media\ >> "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1
ECHO Finished backup of everything except Media: >> "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1
ECHO Begin Media Backup: >> "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1
robocopy \\xxx.xxx.x.xxx\FranArchives\Media\ Y:\ /MIR /FFT /R:0 /MT:4 /XA:SH >> "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1
ECHO Finished backup of Media to Y drive: >> "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1
ECHO DONE! >> "C:\backup\backuplog_%date:~10%%date:~4,2%%date:~7,2%.log" 2>&1

