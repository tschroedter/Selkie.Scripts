[CmdletBinding()]
param (
    [string] $Solution,
    [string] $Source,
    [string] $Package
)

$nuGetExe = "C:\Development\Selkie\Tools\Other\NuGet\NuGet.exe"

& $nuGetExe update $Solution $Package -NonInteractive -source $Source
