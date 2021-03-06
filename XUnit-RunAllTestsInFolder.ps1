[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $testFolder
)
Write-Host -ForegroundColor Green "XUnit-RunAllTestsInFolder" $testFolder
Write-Host -ForegroundColor Green "Processing folder:" $testFolder

$isXUnitDllExe = "C:\Development\Selkie\Tools\Custom\DoesDllContainTests\IsXUnitDll\IsXUnitDll.exe"
$xunit = "C:\Development\Selkie\Tools\Other\xunit-build-1705\xunit.console.clr4.x86.exe"
$tests = Get-ChildItem $testFolder -Recurse -Include *Tests.dll -Exclude *\obj\*
$tests = $tests | where {$_.Fullname.Contains("bin")} | where {-NOT ($_.Fullname.Contains("packages"))}| select -uniq
$xunitTests = @()

ForEach ($test in $tests)
{   
    $isXUnit = & $isXUnitDllExe $test.Fullname
    
    if ($isXUnit -eq "Yes")
    {        
        $xunitTests += $test
        
        Write-Host $test.Name " - Is it a XUnit Dll?" $isXunit
    } 
}    

$xunitTests = $xunitTests | ? {$_}

if ($xunitTests -eq $null)
{
    $numberOfDlls = 0
}
else
{     
    $numberOfDlls = @($xunitTests).Count
}

if ([int]$numberOfDlls -gt [int]0)
{   
    Write-Host -ForegroundColor Green "Running XUnit tests for "$numberOfDlls" DLLs..."

    ForEach ($test in $xunitTests)
    {       
        Write-Host -ForegroundColor DarkGreen "XUnit DLL: " $test.FullName
        
        $projectPath = Split-Path $test.Fullname

        & $xunit "$test" /noshadow /nunit "$projectPath\xunit-test-reports.xml"
    }
}