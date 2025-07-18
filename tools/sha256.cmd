@echo off

rem Verifies sha256sum of file

setlocal enabledelayedexpansion


rem Check arguments

if "%~1" equ "" (
	goto usage
) else if not exist "%1" (
	echo Input path does not exist
	goto error
)

if "%~2" equ "" (
	goto usage
)


rem Hash input file

set "i=0"

for /f "delims=" %%l in ('certutil -hashfile %1 sha256') do (

	set "str=%%l"
	set /a "i+=1"

	if !i! equ 2 (
		set "hash=!str!"
	)

)


rem Verify hash

if "%~2" neq "%hash%" (
	echo Hash does not match
	goto error
) else (
	echo Hash matches
)


endlocal

exit /b 0


:usage

echo Invalid arguments
echo Usage: sha256sum.cmd ^<Input^> ^<Hash^>


:error

endlocal

exit /b 1
