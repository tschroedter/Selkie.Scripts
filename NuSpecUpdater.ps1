[CmdletBinding()]
param (
    [string] $PackageConfig,
    [string] $PackageNuSpec
)

$DependencyUpdaterExe = "C:\Development\Selkie\Tools\Custom\NuSpecUpdater\Selkie.NuGet.DependencyUpdater.exe"

& $DependencyUpdaterExe $PackageConfig $PackageNuSpec