<#
.SYNOPSIS
Find all .cs files in a project folder that are not in \bin or \obj.
 
.DESCRIPTION
Find all .cs files in a project folder that are not in \bin or \obj.
 
.PARAMETER Project
The fullname to the project file.
#>
 
[CmdletBinding()]
param(
    [Parameter(Position=0, 
               Mandatory=$true,
               ValueFromPipeline=$True,
               ValueFromPipelineByPropertyName=$True)]
    [string]$project
)
 
$ErrorActionPreference = "Stop"
$WorkingFolder = ".\Scripts"
$FileType = "*.cs"
$ProjectPath = Split-Path $project
 
$DiskFiles = gci -Path $ProjectPath -Recurse -Filter $FileType | Where-Object { !$_.FullName.Contains("\obj\") -and !$_.FullName.Contains("\bin\")  }  | % { $_.FullName}
$DiskFiles = $DiskFiles | % {$_.ToString()}
 
$Array = @()
 
ForEach($file in $DiskFiles)
{
    $Array += $file
}
 
$Array = $Array | select -unique
 
return $Array