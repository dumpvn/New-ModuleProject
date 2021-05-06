<#PSScriptInfo
.VERSION 
0.0.1

.GUID 
55ef3a83-4365-4e5e-844b-6ab2d323963b

.AUTHOR 
Christian Hoejsager

.COMPANYNAME 
ScriptingChris

.COPYRIGHT
MIT License

Copyright (c) 2021 ScriptingChris

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

.TAGS
module project build

.LICENSEURI 

.PROJECTURI
https://scriptingchris.tech

.ICONURI
N/A

.EXTERNALMODULEDEPENDENCIES
N/A

.REQUIREDSCRIPTS
N/A

.EXTERNALSCRIPTDEPENDENCIES 
N/A

.RELEASENOTES
First deployment of the script
#>

<# 
.SYNOPSIS
Short description
.DESCRIPTION
Script for initiating a new powershell module project
.EXAMPLE
PS C:\> <example usage>
Explanation of what the example does
.INPUTS
Inputs (if any)
.OUTPUTS
Output (if any)
.NOTES
General notes
#>


Param()




<#
# Todo 
    * Prerequisites (SECTION)
        - Download and configure module: psake
        - Download and configure module: platyPS
        - Download and configure module: Pester
        - Download and configure module: PSScriptAnalyzer

    * Initialize (SECTION)
        - Create the folder structure:
            ModuleName
                |_Source
                |   |_Private
                |   |   |_PrivateFunction.ps1
                |   |_Public
                |   |   |_PublicFunction.ps1
                |   |_ModuleName.psd1
                |_Tests
                |_Docs
                |_Output
                |_build.ps1

    * Build (SECTION)
        - Generate the standard psake build scripts

    * WHATIF?
#>


#Region - Prerequisites
if($Prerequisites.IsPresent){
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

    Write-Verbose -Message "Initializing InvokeBuild"
    if (-not(Get-Module -Name psake -ListAvailable)){
        Write-Warning "Module 'psake' is missing or out of date. Installing module now."
        Install-Module -Name psake -Scope CurrentUser -Force
    }
}
#EndRegion - Prerequisites

#Region - Initialize
if($Initialize.IsPresent){
    Write-Verbose -Message "Creating Module folder structure"
    
    try {
        Write-Verbose -Message "Creating Module root folder"
        New-Item -Path "$($Path)\$($ModuleName)" -ItemType Directory    
    }
    catch {
        Write-Error -Message "Error - Failed creating the module root folder"
    }
    if(Test-Path "$($Path)\$($ModuleName)"){
        try {
            Write-Verbose -Message "Creating Source, Tests, Output, Docs folders"
            New-Item -Path "$($Path)\$($ModuleName)\Source" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Tests" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Output" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Docs" -ItemType Directory    
        }
        catch {
            Write-Error -Message "Error - Failed creating Source, Test, Output and Docs folder"
        }
        
        Try {
            Write-Verbose -Message "Creating Private and Public functions folder"
            New-Item -Path "$($Path)\$($ModuleName)\Source\Private" -ItemType Directory
            New-Item -Path "$($Path)\$($ModuleName)\Source\Public" -ItemType Directory
        }
        catch {
            Write-Error -Message "Error - Failed creating private and public functions folders"
        }
    }
}
#EndRegion - Initialize

#Region - Scripts
if($Scripts.IsPresent){
    if(Test-Path "$($Path)\$($ModuleName)"){
        Write-Verbose -Message "Creating the Module Manifest"
        New-ModuleManifest -Path "$($Path)\$($ModuleName)\Source\$($ModuleName).psd1" -ModuleVersion "0.0.1"
    }

    Write-Verbose -Message "Downloading build script from: https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1" -OutFile "$($Path)\$($ModuleName)\build.ps1"

    if(Test-Path "$($Path)\$($ModuleName)\build.ps1"){
        Write-Verbose -Message "Build script was downloaded successfully"
    }
    else {
        throw "Failed to downlaod the buildscript from: https://raw.githubusercontent.com/ScriptingChris/New-ModuleProject/main/Source/build.ps1"
    }
}
#EndRegion - Scripts