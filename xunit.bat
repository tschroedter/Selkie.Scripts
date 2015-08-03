REM C:\Development\Selkie\Tools\Other\xunit-build-1705\xunit.console.clr4.exe %1 /noshadow /nunit opencover-result.xml

REM C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe Set-Location C:\Development\Selkie; .\Scripts\XUnit-RunAllTestsInFolder.ps1 %1
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe Set-Location C:\Development\Selkie; .\Scripts\Run-AllTestsInSolution.ps1 %1