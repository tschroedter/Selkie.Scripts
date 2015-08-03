﻿[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string] $pattern,
    [Parameter(Mandatory=$true)]
    [string] $sourceFolder,
    [Parameter(Mandatory=$true)]
    [string] $nugetServer,
    [Parameter(Mandatory=$true)]
    [string] $apiKey
)

$nuget = "C:\Development\Selkie\Tools\Other\NuGet\nuget.exe"
$files = gci $sourceFolder -rec -filter $pattern | ? { !$_.psiscontainer } 

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
        $packageVersion = $packageVersion -join "."
        
        Write-Host "Name   :" $packageName
        Write-Host "Version:" $packageVersion
                  
        $expected = $packageName + " " + $packageVersion
        $actual = & $nuget list $packageName -Source $nugetServer
        
        Write-Host "Expected: "$expected
        Write-Host "Actual: "$actual
        
        if (-Not ($actual -contains $expected))
        {
            $message = "ERROR: Push didn't work for package '" + $file + "'!"
            throw $message
        }
        else
        {
            Write-Host "Push is confirmed!"
        }
    }
}