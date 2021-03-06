[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})] 
    [string] $Path
)
$WorkingFolder = "C:\Development\Selkie\Scripts\"

$nunitRunner= $workingFolder + "ExecuteAllUnitTests.bat"

$openCoverFolder="C:\Development\Selkie\Tools\Other\Opencover\"
$openCoverExe="OpenCover.Console.exe"
$openCover = $openCoverFolder + $openCoverExe

Write-Host -Foreground Blue "nunitRunner:" $nunitRunner "Path:" $Path

if ($Path -eq $null)
{
    Write-Host "Path is null!"
}
else
{         
    #& $openCover -log:All -target:$nunitRunner -targetargs:$Path -register "-filter:+[Selkie.*]* -[*.Tests]* -[Selkie.*]Test*" -excludebyattribute:"System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage" -hideskipped:All
    #& $openCover -log:All -target:$nunitRunner -targetargs:$Path -register:user -excludebyattribute:*ExcludeFromCodeCoverage* "-filter:+[Selkie.*]* -[*.Tests]*" -hideskipped:All
    & $openCover -log:All -target:$nunitRunner "-targetargs:$pwd $Path" -excludebyattribute:*ExcludeFromCodeCoverage* "-filter:+[Selkie.*]* -[*.Tests]*" -hideskipped:All
}