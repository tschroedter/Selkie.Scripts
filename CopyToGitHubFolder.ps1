[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string] $source,
    [Parameter(Mandatory=$true)]
    [string] $dest
)

$everything = Get-ChildItem $source -Recurse 
$everything = $everything | ?{ $_.fullname -notmatch "\\bin\\?" } | ?{ $_.fullname -notmatch "\\obj\\?" } 
$everything = $everything | ?{ $_.fullname -notmatch "\\.git\\?" }
$everything | Copy-Item -Force -Destination {Join-Path $dest $_.FullName.Substring($source.length)}