<#
.SYNOPSIS
Find and display files in a project folder that are not included in the project.
 
.DESCRIPTION
Find and process files in a project folder that are not included in the project.
 
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
$ProjectName = Split-Path $project -leaf -resolve
 
$ProjectFiles = & $WorkingFolder\Get-FilesIncludedInProject.ps1 $project
$DiskFiles = & $WorkingFolder\Get-FilesInProjectFolder.ps1 $project  
 
$FileNotIncluded = compare-object $DiskFiles $ProjectFiles  -PassThru
$FileNotIncluded = $FileNotIncluded | select -unique
 
$Array = @()

if ($FileNotIncluded)
{ 
    ForEach($file in $FileNotIncluded)
    {
        if (Test-Path $file)
        {
            $Array += $file
        }
    }

    $Array = $Array | select -unique
}
 
return $Array