[CmdletBinding()]
param (
    [string] $Solution,
    [string] $Source
)

$nuGetExe = "C:\Development\Selkie\Tools\Other\NuGet\NuGet.exe"

& $nuGetExe restore $Solution -source $Source
