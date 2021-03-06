[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $testFolder
)
Write-Host -ForegroundColor Green "NUnit-RunAllTestsInFolder" $testFolder
Write-Host -ForegroundColor Green "Processing folder:" $testFolder

$isNUnitDllExe = "C:\Development\Selkie\Tools\Custom\DoesDllContainTests\IsNUnitDll\IsNUnitDll.exe"
$nunit = "C:\Development\Selkie\Tools\Other\NUnit.org\nunit-console\nunit3-console.exe"
$tests = Get-ChildItem $testFolder -Recurse -Include *Tests.dll -Exclude *\obj\*
$tests = $tests | where {$_.Fullname.Contains("bin")} | where {-NOT ($_.Fullname.Contains("packages"))}| select -uniq
$nunitTests = @()

ForEach ($test in $tests)
{  
    $isNUnit = & $isNUnitDllExe $test.Fullname
    
    if ($isNunit -eq "Yes")
    {        
        $nunitTests += $test        
    } 
    
    Write-Host $test.Name " - Is it a NUnit Dll?" $isNunit
}    

$nunitTests = $nunitTests | ? {$_}   
  
if ($nunitTests -eq $null)
{
    $numberOfDlls = 0
}
else
{     
    $numberOfDlls = @($nunitTests).Count
}

if ([int]$numberOfDlls -gt [int]0)
{   
    Write-Host -ForegroundColor Green "Running NUnit tests for "$numberOfDlls" DLLs..."

    ForEach ($test in $nunitTests)
    {
        Write-Host -ForegroundColor DarkGreen "NUnit DLL: " $test.Name
    }

    $results = $testFolder+"\nunit-test-reports.xml;format=nunit2"

    & $nunit --config:Debug --process:Multiple --framework:"net-4.5" --result:$results $nunitTests
}