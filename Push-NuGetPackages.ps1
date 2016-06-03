[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string] $pattern,
    [Parameter(Mandatory=$true)]
    [string] $sourceFolder,
    [Parameter(Mandatory=$true)]
    [string] $nugetServer,
    [Parameter(Mandatory=$false)]
    [string] $nugetServerPull,
    [Parameter(Mandatory=$true)]
    [string] $apiKey,
    [Parameter(Mandatory=$false)]
    [string] $doNotConfirmPush
)

$nuget = "C:\Development\Selkie\Tools\Other\NuGet\nuget.exe"
$files = gci $sourceFolder -rec -filter $pattern | ? { !$_.psiscontainer } 
$files = $files | select -uniq

if ([string]::IsNullOrEmpty($nugetServerPull)) 
{
    $nugetServerPull = $nugetServer

    Write-Host "Info: Set default pull server to: " $nugetServerPull            
}


Write-Host "Pushing packages to server '"$nugetServer"'..."

foreach($file in $files)
{
    Write-Host "Checking file " $file.Name "..."
    
    if ($file.Name.EndsWith(".nupkg"))
    {  
        $message = "Pushing package '" + $file + "' to the server '" + $nugetServer + "'..." 
        Write-Host $message
              
        & $nuget push "$file" -ApiKey $apiKey -Source $nugetServer    
        
        $splitResult = $file.Name.split(".")  
        
        #find version
        $packageName = @()
        $packageVersion = @()
        
        ForEach($part in $splitResult)
        {
            [int]$number = $null
            if ([int32]::TryParse($part , [ref]$number ))
            {
                $packageVersion += $number
            }
            else
            {
                if (-Not ($part -contains "nupkg"))
                {
                    $packageName += $part
                }
            }
        }
        
        $packageName = $packageName -join "."
        $packageVersionNoRevision = $packageVersion[0,1,2]
        $packageVersionNoRevision = $packageVersionNoRevision -join "."
        $packageVersion = $packageVersion -join "."
        
        Write-Host "Name   :" $packageName
        Write-Host "Version:" $packageVersion

        if (!$doNotConfirmPush) 
        {
            Write-Host "Checking server " $nugetServerPull "..." 

            $expected = $packageName + " " + $packageVersionNoRevision
            $actual = & $nuget list $packageName -Source $nugetServerPull            
        
            $expected = $expected.Trim()
            $actual = $actual.Trim()
            $success = $actual.IndexOf($expected)

            Write-Host "Comparing package version..."
            Write-Host "Expected: '"$expected"'"
            Write-Host "Actual: '"$actual"'"
            Write-Host "Success: '"$success"'"

            if ([int32]::$success -lt [int32]::0)
            {
                $message = "ERROR: Push didn't work for package '" + $file + "'!"
                throw $message
            }
            else
            {
                Write-Host "Push is confirmed!"
            }
        }
        else
        {
            Write-Host "Info: Push will not be confirmed!"            
        }
    }
    else
    {
        $message = "Ignoring package '" + $file + "'!" 
        Write-Host $message
    }
}