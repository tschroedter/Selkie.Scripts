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
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string] $Path
)

$ErrorActionPreference = 'Stop'
$WorkingFolder = ".\Scripts"
$ByPassFolder = "powershell -ExecutionPolicy ByPass -File C:\Development\Selkie\Windsor\Scripts"
$Path = ($Path | Resolve-Path).ProviderPath
$SolutionRoot = $Path | Split-Path
$SolutionProjectPattern = @"
(?x)
^ Project \( " \{ FAE04EC0-301F-11D3-BF4B-00C04F79EFBC \} " \)
\s* = \s*
" (?<name> [^"]* ) " , \s+
" (?<path> [^"]* ) " , \s+
"@
 
$ProjectPath = Split-Path $Path
$ProjectName = Split-Path $Path -leaf -resolve
$TotalFilesNotIncluded = 0;

Write-Host -NoNewline -ForegroundColor Green "Searching for lost files"
 
Get-Content -Path $Path |
    ForEach-Object {
        if ($_ -match $SolutionProjectPattern) {
            Write-Host -NoNewline "."
 
            $ProjectPath = $SolutionRoot | Join-Path -ChildPath $Matches['path']
 
            If (Test-Path $ProjectPath){
                #$FileNotInProject = & Get-Content $WorkingFolder\Get-FilesNotInProject.ps1 | Invoke-Expression -project $ProjectPath
                $FileNotInProject = & $WorkingFolder\Get-FilesNotInProject.ps1 $ProjectPath
                $Files = @()
               
                foreach($Item in $FileNotInProject)
                {              
                    if(-Not ([string]::IsNullOrEmpty($item)))
                    {
                        $Files += $Item
                    }
                }
 
                if ($Files.Count -gt 0){
                    Write-Host ""
                    Write-Host -ForegroundColor Red -BackgroundColor black $ProjectPath
                    Write-Host -ForegroundColor DarkRed -BackgroundColor black "Files not included:"$Files.Count
                    ForEach ($File in $Files)
                    {
                        Write-Host -ForegroundColor DarkRed -BackgroundColor black $File
 
                        #
                        #If (Test-Path $File){
                        #    Write-Host -ForegroundColor Yellow -BackgroundColor black "Deleting file" $File
                        #   Remove-Item $File
                        #}
                        #
 
                    }
                    $TotalFilesNotIncluded += $Files.Count
                }
            }Else{
                Write-Host ""
                Write-Host -foregroundcolor Red "Project doesn't exist! -=> $ProjectPath"
            }
        }
    }
 
If ($TotalFilesNotIncluded -gt 0)
{
    $Message = "Error: Found " + $TotalFilesNotIncluded + " file which is not part of any project!";
 
    If ($TotalFilesNotIncluded -gt 1)
    {
        $Message = "Error: Found " + $TotalFilesNotIncluded + " files which are not part of any project!";
    }
 
    Write-Host ""   
    throw $Message
}
Else
{
    Write-Host -NoNewline -ForegroundColor Green "Done!"
    Write-Host
}