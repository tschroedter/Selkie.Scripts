<#
.SYNOPSIS
Find all files in a project which will be compiled.
 
.DESCRIPTION
Find all files in a project which will be compiled.
 
.PARAMETER Project
The fullname to the project file.
#>
 
[CmdletBinding()]
param(
    [Parameter(Position=0, 
               Mandatory=$true,
               ValueFromPipeline=$True,
               ValueFromPipelineByPropertyName=$True)]
    [string]$project
)
$ErrorActionPreference = "Stop"
$ProjectPath = Split-Path $project
$ProjectName = Split-Path $project -leaf -resolve
$XmlProjectFile = [xml](Get-Content $project)
 
$ItemGroup = $XmlProjectFile.Project | ForEach-Object { $_.ItemGroup }
 
$Included = @()
 
ForEach ($Item in $ItemGroup)
{   
    $Type = $Item.GetType()
 
    If ($Type -ne $null-and $Type.Name -eq "XmlElement")
    {
        ForEach ($Child in $Item.ChildNodes)
        {
            if ($Child.Name -eq "Compile")
            {
                $IgnoreBecauseOfLink = "";
 
                # check if <Compile> has a <Link> element
                if ($Child.ChildNodes -ne $null)
                {
                    ForEach($Link in $Child.ChildNodes)
                    {
                        if ($Link.Name -eq "Link")
                        {
                            $IgnoreBecauseOfLink = $Link.InnerText;
                        }
                    }
                }
 
                # ignore <Compile> if a <Link> element was found
                if ($IgnoreBecauseOfLink.Length -eq 0)
                {
                    $Include = $Child.GetAttribute("Include")
                    $IncludeFullPath = $ProjectPath + "\" + $Include
                    $Included += $IncludeFullPath
                }
            }
        }
    }   
}
 
return $Included