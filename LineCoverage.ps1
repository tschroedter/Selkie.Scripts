[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string] $Path
)

$html= gc $Path 

$lineCoveragePattern =  '(?i)<tr><th>Line Coverage:</th><td>(.*)%</td>'
$lineCoverageText = [Regex]::Matches($html, $lineCoveragePattern)

if ($lineCoverageText -eq $null)
{
    Write-Host "Didn't find a coverage file!"
    return -1
}
else
{ 
    try
    {
        $lineCoverageText = $lineCoverageText[0].Groups[1].Value
        $lineCoverageText = $lineCoverageText.Split("%")[0]
        $lineCoverage = [double]$lineCoverageText

        return $lineCoverage
    }
    Catch [system.exception]
    {
        Write-Host "Error: Can't get line coverage!"
        return -1
    }    
}