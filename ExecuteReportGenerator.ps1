[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string] $Path
)
 
$WorkingFolder = ".\Scripts\"

$coverageFolder = $Path + "\coverage"

$reportFolder="C:\Development\Selkie\Tools\Other\ReportGenerator\"
$reportExe="ReportGenerator.exe"
$report = $reportFolder + $reportExe

if (Test-Path -Path $coverageFolder)
{
    Remove-Item $coverageFolder -recurse
    Write-Host "Deleted Coverage Folder: " $coverageFolder
}

& $report -reports:results.xml -targetdir:$coverageFolder -log:All