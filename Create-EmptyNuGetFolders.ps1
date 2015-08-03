<#
.SYNOPSIS
Find and display files in a solution folder which are not in any project.
 
.DESCRIPTION
Find and display files in a solution folder which are not in any project.
 
.PARAMETER Project
The fullname to the solution file.

Example:
powershell -ExecutionPolicy ByPass -File C:\Development\Selkie\Windsor\Scripts\Get-FilesNotInSolution.ps1 C:\Development\Selkie\Windsor\Selkie.Windsor.sln
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string] $Path
)

New-Item -ItemType Directory -Force -Path $Path\lib\net45
New-Item -ItemType Directory -Force -Path $Path\content