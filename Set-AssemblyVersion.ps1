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
# powershell .\SetVersionInfoToBuildNumber.ps1 -versionPrefix ${bamboo.versionPrefix} -buildNumber ${bamboo.buildNumber} -revisionNumber ${bamboo.repository.revision.number}

function Usage
{
  Write-Host "Usage: ";
  Write-Host "  from cmd.exe: ";
  Write-Host "     powershell.exe SetVersion.ps1  2.8.3.0 C:\Temp";
  Write-Host " ";
  Write-Host "  from powershell.exe prompt: ";
  Write-Host "     .\SetVersion.ps1  2.8.3.0 C:\Temp";
  Write-Host " ";
}
 
 
function Update-SourceVersion
{
  Param ([Parameter(Mandatory=$True)]
         [string]$Version,
         [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
         [object[]]$input)
 
  $NewVersion = 'AssemblyVersion("' + $Version + '")';
  $NewFileVersion = 'AssemblyFileVersion("' + $Version + '")';
  $TmpFile = $FileFullPath + ".tmp"
 
  foreach ($o in $input)
  {
    $TmpFile = $o.FullName + ".tmp"
 
     get-content $o.FullName |
        %{$_ -replace 'AssemblyVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $NewVersion } |
        %{$_ -replace 'AssemblyFileVersion\("[0-9]+(\.([0-9]+|\*)){1,3}"\)', $NewFileVersion }  > $TmpFile
 
     move-item $TmpFile $o.FullName -force
  }
}
 
 
function Update-AllAssemblyInfoFiles ( $Version, $Path )
{
    get-childitem -recurse $Path |? {$_.Name -eq "AssemblyInfo.cs"} | Update-SourceVersion $Version ;   
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