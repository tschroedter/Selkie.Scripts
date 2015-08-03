[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string] $solutionPath,
    [Parameter(Mandatory=$true)]
    [string] $solutionName,
    [Parameter(Mandatory=$true)]
    [string] $resharperResult
)
 
#$solutionName = $solution = Split-Path $solution -leaf -resolve
$resharperExeFolder = "C:\Development\Selkie\Tools\Other\ReSharperCommandLineTools"
$resharperExe = "inspectcode.exe"
$resharperFullname = $resharperExeFolder +"\" + $resharperExe
$profileFolder = "C:\Development\Selkie\Tools\ReSharper"
$profileName = "Selkie.DotSettings"
$profileFullname = $profileFolder + "\" + $profileName 

if (Test-Path $resharperResult)
{
    Write-Host -ForegroundColor Green "Remove old result..."
    Remove-Item $resharperResult -recurse
}

Write-Host -ForegroundColor Green "Running ReSharper (InspectCode)..."
Set-Location $solutionPath
& $resharperFullname "$solutionName" /p="$profileFullname" /o="$resharperResult"
 
[xml] $resultFile = Get-Content $resharperResult
$issueTypes = $resultFile.Report.IssueTypes.IssueType
$projects = $resultFile.Report.Issues.Project

$numberOfIssueTypes = $resultFile.Report.IssueTypes.ChildNodes.Count

if ([int]$numberOfIssueTypes -ne [int]0)
{
    $numberOfIssueTypes = 0
     
    ForEach($issueType in $issueTypes)
    {  
        Write-Host "Severity" $issueType.Severity "Description:" $issueType.Description
        
        if (($issueType.Severity -ne "SUGGESTION") -and
            ($issueType.Severity -ne "HINT"))
        {
            $numberOfIssueTypes = $numberOfIssueTypes + 1
        }
    }
}

Write-Host "Found a total of " $numberOfIssueTypes "issue types."


if ([int]$numberOfIssueTypes -ne [int]0)
{
    $totalIssues = 0;
     
    ForEach($project in $projects)
    {
        $projectName = $project | Select-Object -Property Name
        $issuesCount = $project.ChildNodes.Count
        $issuesMessage = "Found " + $issuesCount + " issues in project '" + $projectName.Name + "'!"
     
        Write-Host -ForegroundColor DarkRed $issuesMessage
     
        $totalIssues = $totalIssues + $issuesCount
    }  

    $message = "Error: Found " + $totalIssues + " ReSharper issue(s) in solution!"
 
    throw $message
}
else
{
    Write-Host -NoNewline -ForegroundColor Green "Done!"
}