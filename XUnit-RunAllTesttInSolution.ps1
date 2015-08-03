[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $solutionPath
)

$workingFolder = "Scripts\"
$tests = (Get-ChildItem $solutionPath -Recurse -Include *Tests.dll) | Where-Object { !$_.FullName.Contains("\obj\") } 
$testsFolders = $tests | Split-Path | select -uniq

Write-Host -ForegroundColor Green "Run all XUnit test in solution folder..."
Write-Host -ForegroundColor Green "Found"$testsFolders.Count"folders(s) containg tests..."

ForEach ($testFolder in $testsFolders)
{  
    & $workingFolder\XUnit-RunAllTests.InFolder.ps1 $testFolder
}

Write-Host -NoNewline -ForegroundColor Green "...Done!"
