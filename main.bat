@echo off

goto :Main


:Banner
echo.
echo    __    ____  ____       __    ___  ___  ____  ___  ____   __    _  _  ____ 
echo   /__\  (  _ \(  _ \     /__\  / __)/ __)(_  _)/ __)(_  _) /__\  ( \( )(_  _)
echo  /(__)\  ) _  )(_) )   /(__)\ \__ \\__ \ _)(_ \__ \  )(  /(__)\  )  (   )(  
echo (__)(__)(____/(____/   (__)(__)(___/(___/(____)(___/ (__)(__)(__)(_)\_) (__)  Version 1.0.0 
echo.
echo                     From Ajtech   Auther : Ajmal CP
echo.                                                                                  
goto :eof

:CheckPgm
    setlocal

        tasklist /fi "ImageName eq adb.exe" /fo csv 2>NUL | find /I "adb.exe">NUL

    endlocal & set isRunning=%ERRORLEVEL%
goto :eof


:PROMPT
setlocal
    CHOICE /N /C:YN /M "Are You Want To Restart Adb Server? Y/N"%1
    IF %ERRORLEVEL% EQU 1 goto KillServer
endlocal 
goto :eof


:DicscoPrompt
setlocal
    CHOICE /N /C:LDS  /M "List Of Connected Devices [L] Disconnect All [D] Skip [S] "%1
    IF %ERRORLEVEL% EQU 1 bin\adb devices -l && goto :DicscoPrompt
    IF %ERRORLEVEL% EQU 2 bin\adb disconnect && goto :ToConnectDevice

endlocal 
goto :eof




:KillServer
    echo Killing server...
    taskkill /F /IM adb.exe
    timeout /t 3 /nobreak
    cls
    
    goto Main
goto :eof

:Main
   call :Banner
    set isRunning=
    set isConnected=
    set conn=
    call :CheckPgm
    IF %isRunning% ==0 (
        echo Adb Server Is Already Running
        call :PROMPT
    cls
    ) ELSE (
        echo Adb server Starting...
        bin\adb start-server
        cls
     )
     call :AdbCheckDevices
    if %isConnected% EQU 0 (
        cls
        call :Banner
        echo.
        echo.
        echo No connected Devices
        call :ToConnectDevice




    ) else if %isConnected% EQU 1 (
        cls
       
        call :Banner
        echo.
        echo.
        echo Connected Devices Found
        call :DicscoPrompt
        goto :Menu
    )

 goto :eof




:AdbCheckDevices

    bin\adb devices -l | find "device product:" >nul
   
        if errorlevel 1 (
            set isConnected=0
         
        ) else (
            set isConnected=1
          
        )

    goto :eof

:ToConnectDevice
CLS
   call :Banner
   :DevIp
   
    set devIp=
        echo.
        echo Create a new connection
            set /p devIp= [Enter Device Ip ] :
            IF [%devIp%] EQU []  goto DevIp
            cls
            bin\adb connect %devIp%
            

            
            bin\adb connect %devIp% | find "connected to %DevIp%" >nul 
            echo.
            if %errorlevel% EQU 1 (
                cls
                echo Something went wrong  please try again
            echo.

             goto :ToConnectDevice
         
        ) else (
             cls
             
              echo Successfully Connected to %DevIp% 
              timeout /t 1 /nobreak
          
        )
                
               
        goto :Menu
              

 goto :eof

:Menu
    
    CLS
    call :Banner
    ECHO 1.  List connected device
    ECHO 2.  Install App 
    ECHO 3.  Uninstall App
    echo 4.  Packages
    ECHO 5.  Exit
    ECHO.
    ECHO.
    ECHO.
    CHOICE /N /C:123456   /M "Enter your choice:"

    :: Note - list ERRORLEVELS in decreasing order
    IF ERRORLEVEL 5 exit /b 0
    IF %ERRORLEVEL%  EQU 4 goto :packagesMenu
    IF %ERRORLEVEL%  EQU 3 goto :uninstallApp
    IF %ERRORLEVEL%  EQU 2 goto :installApp
    IF %ERRORLEVEL%  EQU 1 goto :Listdev
   



:Listdev
    cls
    call :Banner
    bin\adb devices -l
    CHOICE /N /C:BEDR /M "Back [B] Exit [E] Disconnect All [D] Reboot [R]"
    IF ERRORLEVEL 4 goto :Reboot
    IF ERRORLEVEL 3 goto :disconnectAll
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu

    goto :eof

:installApp
    cls
    call :Banner
    set appName=
    
    set /p appName=[Enter File Name With Path] : 
    bin\adb install "%appname%"
     CHOICE /N /C:BER /M "Back [B] Exit [E] Next [N]"
    IF ERRORLEVEL 3 goto :installApp

    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
     goto :eof





:uninstallApp
    setlocal
        cls
        call :Banner
        set packageName=
        
        set /p packageName=[Enter Package Name] : 
        bin\adb shell pm uninstall -k --user 0 %packageName%
        CHOICE /N /C:BER /M "Back [B] Exit [E] Retry [R]"
        IF ERRORLEVEL 3 goto :uninstallApp

        IF ERRORLEVEL 2 exit /b 0
        IF ERRORLEVEL 1 goto :Menu
    endlocal
   goto :eof


:listAllPack
    setlocal
        cls
        call :Banner
        bin\adb shell pm list packages
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
    endlocal
    goto :eof


:listSysPack
    setlocal
        cls
        call :Banner
        bin\adb shell pm list packages -s
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu

    endlocal
    goto :eof


:list3rdPack
    setlocal
        cls
        call :Banner
        bin\adb shell pm list packages -3
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
    endlocal
    goto :eof

:disableppPack
    setlocal
        cls
        call :Banner
        bin\adb shell pm list packages -d
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
    endlocal
    goto :eof


:enabledppPack
    setlocal
        cls
        call :Banner
        bin\adb shell pm list packages -e
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
    endlocal
    goto :eof

:uninstalledppPack
    setlocal
        cls
        call :Banner
        bin\adb shell pm list packages -u
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
    endlocal
    goto :eof

:reboot
    setlocal
        cls
        call :Banner
        bin\adb reboot
        CHOICE /N /C:BE /M "Back [B] Exit [E]"
    IF ERRORLEVEL 2 exit /b 0
    IF ERRORLEVEL 1 goto :Menu
    endlocal
    goto :eof

:disconnectAll
    setlocal
        cls
        bin\adb disconnect 
        goto :ToConnectDevice
    endlocal
    goto :eof


:packagesMenu
cls
        call :Banner
    setlocal
    ECHO 1.  List all packages
    ECHO 2.  List system packages
    ECHO 3.  List 3rd-party packages
    ECHO 4.  Disabled app packages
    ECHO 5.  Enabled app packages
    ECHO 6.  List uninstall app packages
    ECHO 7.  Back
    ECHO 8.  Exit
    echo.
    echo.
    CHOICE /N /C:12345678   /M "Enter your choice:"

    IF ERRORLEVEL 8 exit /b 0
    IF ERRORLEVEL 7 goto :Menu
    IF %ERRORLEVEL%  EQU 6 goto :uninstalledppPack
    IF %ERRORLEVEL%  EQU 5 goto :enabledppPack
    IF %ERRORLEVEL%  EQU 4 goto :disableppPack
    IF %ERRORLEVEL%  EQU 3 goto :list3rdPack
    IF %ERRORLEVEL%  EQU 2 goto :listSysPack
    IF %ERRORLEVEL%  EQU 1 goto :listAllPack
  

    endlocal
goto eof