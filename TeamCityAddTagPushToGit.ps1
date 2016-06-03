[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string] $repositoryUrl,
    [Parameter(Mandatory=$true)]
    [string] $versionNumber,
    [Parameter(Mandatory=$true)]
    [string] $planName
)

Write-Host "repositoryUrl     :" $repositoryUrl
Write-Host "planName          :" $planName
Write-Host "versionNumber     :" $versionNumber


Write-Host "Set location..."
Set-Location .\Source
Write-Host $pwd

Write-Host "Add remote..."
git remote add origintopush $repositoryUrl

Write-Host "Adding user"
git config --global user.email "Thomas.Schroedter@gmx.net"
git config --global user.name "thomas"

Write-Host "Checkout branch..."
git checkout -b $versionNumber

Write-Host "Adding changes..."
git add -A .

Write-Host "Commit changes..."
git commit -m 'Bamboo Build: Commited updated files'

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
