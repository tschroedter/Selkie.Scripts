[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string] $pattern,
    [Parameter(Mandatory=$true)]
    [string] $sourceFolder,
    [Parameter(Mandatory=$true)]
    [string] $destinationFolder
)

$nuGetExe = "C:\Development\Selkie\Tools\Other\NuGet\NuGet.exe"
$nugetServer = "http://localhost/Selkie.LocalNuGetServer/"
$apiKey = "5D5B71F3-E1AA-4D68-B1E7-B63213896E29"

#$nugetServer = "http://localhost:8095/nuget/packages"
#$apiKey = "API-XXDOOJGLFNCD6WN9GGSPJXYD28"

$files = gci $sourceFolder -rec -filter $pattern | ? { !$_.psiscontainer } 

#Write-Host "Set ApiKey for server '" + $nugetServer + "' to '" + $apiKey + "'..."
#Tools\NuGet\nuget.exe setapikey $apiKey -Source $nugetServer

Write-Host "Pushing packages to server '"$nugetServer"'..."

foreach($file in $files)
{
    $message = "Pushing package '" + $file + "' to the server '" + $nugetServer + "'..." 
    Write-Host $message
      
    $nuGetExe push "$file" -ApiKey $apiKey -Source $nugetServer    
}