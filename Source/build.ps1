param (
    [ValidateSet("Release", "debug")]$Configuration = "debug",
    [Parameter(Mandatory=$false)]$ModuleVersion
)

task Init {
    #Todo - Initializing build sequence with modules and dependencies
    Write-Verbose -Message "Initializing Module PSScriptAnalyzer"
    if (-not(Get-Module -Name PSScriptAnalyzer -ListAvailable)){
        Write-Warning "Module 'PSScriptAnalyzer' is missing or out of date. Installing module now."
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing Module Pester"
    if (-not(Get-Module -Name Pester -ListAvailable)){
        Write-Warning "Module 'Pester' is missing or out of date. Installing module now."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing platyPS"
    if (-not(Get-Module -Name platyPS -ListAvailable)){
        Write-Warning "Module 'platyPS' is missing or out of date. Installing module now."
        Install-Module -Name platyPS -Scope CurrentUser -Force
    }
}

task Test {

    #Todo running PSScriptAnalyzer and Pester tests
    try {
        Write-Verbose -Message "Running PSScriptAnalyzer on Public functions"
        Invoke-ScriptAnalyzer "./Public" -Recurse
        Write-Verbose -Message "Running PSScriptAnalyzer on Private functions"
        Invoke-ScriptAnalyzer "./Private" -Recurse
    }
    catch {
        throw "Couldn't run Script Analyzer"
    }

    Write-Verbose -Message "Running Pester Tests"
    $Results = Invoke-Pester -Script "../Tests/*.ps1" -OutputFormat NUnitXml -OutputFile "../Tests/TestResults.xml"
    if($Results.FailedCount -gt 0){
        throw "$($Results.FailedCount) Tests failed"
    }
}

task Build {

    #Todo - Building the Module wether the build configuration is set to 'debug' or 'release'

}

task Clean {

    #Todo - clean temp folders

}

task Publish -if($Configuration -eq "Release"){

    #Todo - Release module to PowerShell Gallery

}

task . Init, Test, Build, Clean, Publish