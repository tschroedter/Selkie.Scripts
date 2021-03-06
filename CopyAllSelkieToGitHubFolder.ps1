$workingFolder = "C:\Development\Selkie\Scripts\"

# Copy Core
$githubFolder = 'C:\Development\GitHub\Selkie\'
$source = 'C:\Development\Selkie'
$folders = Get-ChildItem $source | ?{ $_.PSIsContainer } | ?{ $_.fullname -notmatch "\\Services\\?" } 


ForEach ($folder in $folders)
{  
    $githubSubFolder = $githubFolder + $folder.Name
    
    if(!(Test-Path -Path $githubSubFolder ))
    {
        New-Item -ItemType directory -Path $githubSubFolder
    }
    
    Write-Host 'Copying folder from ' $folder.Fullname ' to ' $githubSubFolder
    & $workingFolder\CopyToGitHubFolder.ps1 $folder.Fullname $githubSubFolder
}

# Copy Services
$githubFolder = 'C:\Development\GitHub\Selkie\Services\'
$source = 'C:\Development\Selkie\Services\'
$folders = Get-ChildItem $source | ?{ $_.PSIsContainer }


ForEach ($folder in $folders)
{  
    $githubSubFolder = $githubFolder + $folder.Name
    
    if(!(Test-Path -Path $githubSubFolder ))
    {
        New-Item -ItemType directory -Path $githubSubFolder
    }
    
    Write-Host 'Copying folder from ' $folder.Fullname ' to ' $githubSubFolder
    & $workingFolder\CopyToGitHubFolder.ps1 $folder.Fullname $githubSubFolder
}