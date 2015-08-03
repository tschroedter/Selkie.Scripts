# Set-AssemblyVersion.ps1
#
# Set the version in all the AssemblyInfo.cs files in any subdirectory.
#
# usage: 
#  from cmd.exe:
#     powershell.exe Set-AssemblyVersion.ps1  2.8.3.0 C:\Temp
#
#  from powershell.exe prompt:
#     .\Set-AssemblyVersion.ps1  2.8.3.0 C:\Temp
#
# powershell .\Set-NuGetVersion.ps1 -versionPrefix ${bamboo.versionPrefix} -buildNumber ${bamboo.buildNumber} -revisionNumber ${bamboo.repository.revision.number}

function Usage
{
  Write-Host "Usage: ";
  Write-Host "  from cmd.exe: ";
  Write-Host "     powershell.exe Set-NuGetVersion.ps1  2.8.3.0 C:\Temp\package.nuspec";
  Write-Host " ";
  Write-Host "  from powershell.exe prompt: ";
  Write-Host "     .\Set-NuGetVersion.ps1  2.8.3.0 C:\Temp\package.nuspec";
  Write-Host " ";
}
 
function Update-AllAssemblyInfoFiles ([string] $Version, [string] $FileFullPath )
{
  $NewVersion = '<version>' + $Version + '</version>'
  $TmpFile = $FileFullPath + ".tmp"
 
  $TmpFile = $FileFullPath + ".tmp"
 
  get-content $FileFullPath | %{$_ -replace "<version>.*<\/version>", $NewVersion } > $TmpFile
 
  move-item $TmpFile $FileFullPath -force
}
 
 
# validate arguments
$r= [System.Text.RegularExpressions.Regex]::Match($args[0], "^[0-9]+(\.[0-9]+){1,3}$");
 
if ($r.Success)
{
    Update-AllAssemblyInfoFiles $args[0] $args[1];
}
else
{
  Usage ;
 
  throw "Error: Bad Input!"
} 