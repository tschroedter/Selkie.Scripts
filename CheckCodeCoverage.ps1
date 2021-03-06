[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string] $Path
)

$html= gc $Path 

$lineCoverageRequired = [double]90.0

$patternBranchCoverage =  '(?i)<tr><th>Branch coverage:</th><td>(.*)%</td>'
$branchCoverageText = [Regex]::Matches($html, $patternBranchCoverage)
$branchCoverageText = $branchCoverageText[0].Groups[1].Value
$branchCoverageText = $branchCoverageText.Split("%")[0]
$branchCoverage = [double]$branchCoverageText

$lineCoveragePattern =  '(?i)<tr><th>Line Coverage:</th><td>(.*)%</td>'
$lineCoverageText = [Regex]::Matches($html, $lineCoveragePattern)
$lineCoverageText = $lineCoverageText[0].Groups[1].Value
$lineCoverageText = $lineCoverageText.Split("%")[0]
$lineCoverage = [double]$lineCoverageText

Write-Host "Line Coverage  : " $lineCoverage"%"
Write-Host "Branch Coverage: " $branchCoverage"%"

If ($lineCoverage -lt $lineCoverageRequired)
{
    $Message = "Error: Current line code coverage is " + $lineCoverage + "% but the required coverage is " + $lineCoverageRequired + "%!";
 
    Write-Host ""   
    throw $Message
}
Else
{
    Write-Host -NoNewline -ForegroundColor Green "Done!"
    Write-Host
}