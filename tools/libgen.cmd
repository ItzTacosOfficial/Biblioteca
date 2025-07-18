@echo off

rem Generate library files from DLL

setlocal enabledelayedexpansion


rem Check for Visual Studio enviroment

where /q lib.exe && where /q dumpbin.exe

if %errorlevel% neq 0 (
	echo Visual Studio enviroment not initialized
	goto error
)


rem Check arguments

if "%~1" equ "" (
	goto usage
) else if not exist "%1" (
	echo DLL path does not exist
	goto error
)

if "%~2" equ "" (
	goto usage
) else if not exist "%2/" (
	echo Output directory does not exist
	goto error
)

if "%~3" equ "" (
	goto usage
) else (
	set "machine=%~3"
)


rem Set up paths

set "lib=%2/%~n1.lib"
set "dump=%2/%~n1.dump"
set "def=%2/%~n1.def"
set "exp=%2/%~n1.exp"

if exist "%lib%"	del %lib%
if exist "%dump%"	del %dump%
if exist "%def%"	del %def%
if exist "%exp%"	del %exp%


rem Dump binary exports

dumpbin /exports %1 > %dump%

if %errorlevel% neq 0 (
	echo Error at dumpbin.exe
	goto error
)


rem Create module definition

echo EXPORTS > %def%

set "i=0"

for /f "delims=" %%l in (%dump%) do (

	set "str=%%l"
	set /a "i+=1"

	if !i! equ 10 (
		set /a "end=str"
		set /a "end+=13"
	)

	if !i! gtr 12 if !i! lss !end! (
		echo !str:~26! >> %def%
	)

)


rem Generate lib

lib /nologo /machine:%machine% "/def:%def%" "/out:%lib%" >nul

if %errorlevel% neq 0 (
	echo Error at lib.exe
	goto error
)


endlocal

exit /b 0


:usage

echo Invalid arguments
echo Usage: libgen.cmd ^<DLL Path^> ^<Output Directory^> ^<Machine^>


:error

endlocal

exit /b 1
