[CmdletBinding()]
param (
    [string] $ZipFileName,
    [string] $Path
)

$7zExe = "C:\Development\Selkie\Tools\Other\7-Zip\7z.exe"

& $7zExe $ZipFileName $Path