@echo off
chcp 866
set "<=["
set ">=[0m"
set "F_Red=41m"
set "F_Green=42m"
set 
:menu
cls
net session >nul 2>&1
echo ULTRA.bat by k3b4b
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if %errorLevel% == 0 (
  echo %<%%F_GREEN%ULTRA.bat запущен от имени администратора.%>%
) else (
  echo %<%%F_RED%ULTRA.bat запущен не от имени администратора!!!%>%
)
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo Выберите нужный пункт:
echo 1. Диспетчер устройств
echo 2. Службы
echo 3. ipconfig /all
echo 4. Плагины iiko
echo 5. CashServer
echo 6. Перезапуск УТМ
echo 7. Запуск ДТО АТОЛ
echo 8. Настройка доступа к AnyDesk
echo 9. Пинг в 15 пакетов
set /p choice=Введите номер пункта:
 
if %choice%==1 goto devmgr
if %choice%==2 goto services
if %choice%==3 goto ipconfig
if %choice%==4 goto iikoplugins
if %choice%==5 goto cashserver
if %choice%==6 goto restartutm
if %choice%==7 goto dto
if %choice%==8 goto anydeskpassword
if %choice%==9 goto pingsomething
 
echo Некорректный выбор. Пожалуйста, выберите пункт из списка.
pause
goto menu
 
:devmgr
start devmgmt.msc
goto end
 
:services
start services.msc
goto end
 
:ipconfig
ipconfig /all
goto end
 
:iikoplugins
explorer "C:\Program Files\iiko\iikoRMS\Front.Net\Plugins"
goto end
 
:cashserver
explorer "%appdata%\iiko\CashServer"
goto end
 
:restartutm
echo Получение PID службы Transport...
for /f "tokens=2" %%i in ('sc queryex "Transport" ^| findstr PID') do set PID=%%i
echo PID службы "Transport": %PID%
echo Принудительное завершение службы "Transport"...
taskkill /f /pid %PID%
echo Служба "Transport" завершена.
echo Завершение процесса "UTM.exe"...
taskkill /f /im UTM.exe
echo Процесс "UTM.exe" завершён.
echo Запуск службы "Transport"...
net start "Transport"
echo Служба "Transport" запущена.
start "C:\UTM\UTM.exe"
echo UTM запущен.
goto end
 
:dto
IF EXIST "C:\Program Files (x86)\ATOL" (
    IF EXIST "C:\Program Files (x86)\ATOL\Drivers10" (
        start "" "C:\Program Files (x86)\ATOL\Drivers10\KKT\bin\fptr10_t.exe"
        goto end
    ) ELSE (
        start "" "C:\Program Files (x86)\ATOL\Drivers8\Bin\FprnM_T.exe"
        goto end
    )
)
IF EXIST "C:\Program Files\ATOL" (
    IF EXIST "C:\Program Files\ATOL\Drivers10" (
        start "" "C:\Program Files\ATOL\Drivers10\KKT\bin\fptr10_t.exe"
        goto end
    ) ELSE (
        start "" "C:\Program Files\ATOL\Drivers8\Bin\FprnM_T.exe"
        goto end
    )
)
echo ДТО АТОЛ не обнаружено.
goto end
 
:anydeskpassword
set "psCommand=powershell -Command "$pword = read-host 'Введите пароль' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p
"C:\Program Files (x86)\AnyDesk\AnyDesk.exe" --set-password %password%
echo Если не возникло ошибок - пароль был изменён.
goto end
 
:pingsomething
set /p ipaddress=Введите IP-адрес:
ping %ipaddress% -n 15
goto end
 
:end
echo Нажмите любую клавишу чтоб вернуться в меню...
pause
cls
goto menu
