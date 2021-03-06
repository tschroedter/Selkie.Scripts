[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string] $Path,
    [Parameter(Mandatory=$false)]
    [double] $LineCoverageRequired=90
)
 
$WorkingFolder = ".\Scripts\"

$openCover = $WorkingFolder + "ExecuteOpenCover.ps1"
$reportGenerator = $WorkingFolder + "ExecuteReportGenerator.ps1"
$lineCoverageScript = $WorkingFolder + "LineCoverage.ps1"
$coverageFolder = $Path + "\coverage\"
$coverageFile = $coverageFolder + "index.htm"


if(!(Test-Path -Path $coverageFolder )){
    New-Item -ItemType directory -Path $coverageFolder
    Write-Host "Created missing coverage folder: " $coverageFolder
}

Write-Host "Executing: " $openCover
& $openCover $Path

Write-Host "Executing: " $reportGenerator
& $reportGenerator $Path

Write-Host "Executing: " $lineCoverage
$lineCoverage = & $lineCoverageScript $coverageFile

$lineCoverage = [double]$lineCoverage

If ($lineCoverage -lt $LineCoverageRequired)
{
    $Message = "Error: Current line code coverage is " + $lineCoverage + "% but the required coverage is " + $lineCoverageRequired + "%!";
 
    Write-Host ""   
    throw $Message
}
Else
{
    Write-Host -ForegroundColor Green "Line Coverage"
    Write-Host -ForegroundColor Green "-------------"
    Write-Host -ForegroundColor Green "Actual  : " $lineCoverage"%"
    Write-Host -ForegroundColor Green "Expected: " $lineCoverageRequired"%"
    Write-Host -ForegroundColor Green "...Done!"
    Write-Host
}