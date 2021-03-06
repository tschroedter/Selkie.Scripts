[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $solutionPath
)

if ($solutionPath -eq $null)
{
    Write-Host -NoNewline -ForegroundColor Green "Path is null!"
}
else
{
    $coverageFolder = $solutionPath + "\coverage\"

    if(!(Test-Path -Path $coverageFolder )){
        New-Item -ItemType directory -Path $coverageFolder
        Write-Host "Created missing coverage folder: " $coverageFolder
    }

     
    $workingFolder = "C:\Development\Selkie\Scripts\"
    $tests = (Get-ChildItem $solutionPath -Recurse -Include "*Tests.dll") | Where-Object { !$_.FullName.Contains("\obj\") } | Where-Object { !$_.FullName.Contains("\packages\") }

    if ($tests -eq $null)
    {
        Write-Host -NoNewline -ForegroundColor Green "No test DLLs found!"
    }
    else
    {    
        $testsFolders = $tests | Split-Path | select -uniq

        Write-Host -ForegroundColor Green "Run all NUnit and XUnit test in solution folder..."
        Write-Host -ForegroundColor Green "Found"$testsFolders.Count"folders(s) containg tests..."

        if ($testsFolders -eq $null)
        {
            Write-Host "Didn't find any test DLLs!"
        }
        else
        {     
            ForEach ($testFolder in $testsFolders)
            {  
                $testPath = Convert-Path $testFolder

                & $workingFolder\NUnit-RunAllTestsInFolder.ps1 $testPath
                & $workingFolder\XUnit-RunAllTestsInFolder.ps1 $testPath
            }
        }
    }
    Write-Host -NoNewline -ForegroundColor Green "...Done!"
}