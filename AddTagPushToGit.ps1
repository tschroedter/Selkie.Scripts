[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $repositoryUrl,
    [Parameter(Mandatory=$true)]
    [string] $majorVersionNumber,
    [Parameter(Mandatory=$true)]
    [string] $minorVersionNumber,
    [Parameter(Mandatory=$true)]
    [string] $buildNumber,
    [Parameter(Mandatory=$true)]
    [string] $planName
)

$versionNumber = $majorVersionNumber + "." + $minorVersionNumber + "." + $buildNumber + ".0"

Write-Host "repositoryUrl     :" $repositoryUrl
Write-Host "majorVersionNumber:" $majorVersionNumber
Write-Host "minorVersionNumber:" $minorVersionNumber
Write-Host "buildNumber       :" $buildNumber
Write-Host "planName          :" $planName
Write-Host "versionNumber     :" $versionNumber


Write-Host "Set location..."
Set-Location .\Source
Write-Host $pwd

Write-Host "Add remote..."
git remote add origintopush $repositoryUrl

Write-Host "Checkout branch..."
git checkout -b $versionNumber

Write-Host "Adding changes..."
git add -A .

Write-Host "Commit changes..."
git commit -m 'Bamboo Build: Commited updated a files'

Write-Host "Pushing changes..."
git push origintopush $versionNumber

#Write-Host "Create tag..."
#git tag -f -a $versionNumber -m "$planName build number $buildNumber passed automated acceptance testing."

#Write-Host "Push to server..."
#git push --tags origintopush $versionNumber

#Write-Host "List tags in cache..."
#git ls-remote --exit-code --tags origintopush $versionNumber

Write-Host "Set location..."
Set-Location .\
Write-Host $pwd
