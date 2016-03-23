[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string] $version,
    [Parameter(Mandatory=$true)]
    [string] $Source
)

$updaterExeFolder = "C:\Development\Selkie\Tools\Custom\VersionVDProj\"
$updaterdExe = "VersionVDProj.exe"
$updater = $updaterExeFolder + $updaterdExe

$allFiles = Get-ChildItem $Source -Recurse
$vdprojs = $allFiles | where {$_.Extension -eq ".vdproj"}
$vdprojs | format-table name

ForEach($vdproj in $vdprojs)
{
    Write-Host "Updating version number in project: " $vdproj
    Write-Host $updater -msi $vdproj version=$version
    & $updater -msi $vdproj.FullName version=$version
}