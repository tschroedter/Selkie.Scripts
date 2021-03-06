function CreateXUnitXmlFile
{
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $path,
    [Parameter(Mandatory=$true)]
    [string] $xunitXmlFileName)

    #$path = "C:\Development\Selkie\Services\Racetracks"
    #$fileName = "C:\Temp\File.txt"

    $xunitTests = GetDLLsContainingXUnitTests $path

    $assembliesXml = CreateXmlForDlls $xunitTests

    $xunitXml = CreateXmlXunitFile $assembliesXml

    SaveXmlToFile $xunitXml $xunitXmlFileName
}

function GetDLLsContainingXUnitTests ([string]$testFolder)
{
    $isXUnitDllExe = "C:\Development\Selkie\Tools\Custom\DoesDllContainTests\IsXUnitDll\IsXUnitDll.exe"
    $tests = Get-ChildItem $testFolder -Recurse -Include *Tests.dll -Exclude *\obj\*
    $tests = $tests | where {$_.Fullname.Contains("bin")} | where {-NOT ($_.Fullname.Contains("packages"))}| select -uniq
    $xunitTests = @()

    ForEach ($test in $tests)
    {      
        $isXUnit = & $isXUnitDllExe $test.Fullname
                
        if ($isXUnit -eq "Yes")
        {        
            $xunitTests += $test        
        } 
    }    

    $xunitTests = $xunitTests | ? {$_}
    
    return $xunitTests
}

function CreateXmlForDlls ([string[]]$xunitTests)
{
    $xmlPerDll = @()

    ForEach ($test in $xunitTests)
    {               
        $xmlPerDll += "<assembly filename=`"" + $test + "`" shadow-copy=`"false`" />"
    }
    
    return $xmlPerDll
}

function CreateXmlXunitFile ([string[]]$assembliesXml)
{
    $xml = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`r`n" +
           "<xunit>`r`n" +
           "<assemblies>`r`n"
           
    ForEach ($test in $assembliesXml)
    {          
        $xml = $xml + $test + "`r`n"
    }
    
    $xml = $xml + 
           "</assemblies>`r`n" +
           "</xunit>`r`n"
             
    return $xml
}

function SaveXmlToFile ([string]$xunitXml,
                        [string]$fileName)
{
    Write-Host "Writing XML to file'"$fileName"'"
    
    If (Test-Path $fileName)
    {
    	Remove-Item $fileName
    }
        
    $xunitXml | Out-File $fileName    
}