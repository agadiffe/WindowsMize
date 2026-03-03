#=================================================================================================================
#                                               New User GPO Script
#=================================================================================================================

<#
.SYNTAX
    New-UserGpoScript
        [-FilePath] <string>
        [[-Parameter] <string>]
        [-Type] {Logon | Logoff}
        [<CommonParameters>]
#>

function New-UserGpoScript
{
    <#
    .EXAMPLE
        PS> New-UserGpoScript -FilePath 'C:\MyScript.ps1' -Type 'Logoff'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [string] $Parameter = '',

        [Parameter(Mandatory)]
        [GpoScriptType] $Type
    )

    process
    {
        $GpoPath = "$env:SystemRoot\System32\GroupPolicy"
        $UserGpoScriptsPath = "$GpoPath\User\Scripts"
        $UserGpoScriptsIniFilePath = "$UserGpoScriptsPath\scripts.ini"
        $UserGpoPSScriptsIniFilePath = "$UserGpoScriptsPath\psscripts.ini"
        $GptIniFilePath = "$GpoPath\gpt.ini"

        'Logon', 'Logoff' | ForEach-Object -Process {
            New-Item -ItemType 'Directory' -Path "$UserGpoScriptsPath\$_" -ErrorAction 'SilentlyContinue' | Out-Null
        }

        # gpt.ini
        $UserGpoScriptExtensions = '{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B66650-4972-11D1-A7CA-0000F87571E3}'
        $GptIniVersion = 65536 # 0x00010000

        $GptIniContent = Get-Content -Raw -Path $GptIniFilePath -ErrorAction 'SilentlyContinue'
        $GptIniData = ConvertFrom-Ini -InputObject $GptIniContent

        if (-not $GptIniData['General'])
        {
            $GptIniData['General'] = @{}
        }

        $GptIniData['General']['Version'] = $GptIniData['General']['Version'] ?
            [bigint]$GptIniData['General']['Version'] + $GptIniVersion : $GptIniVersion

        if ($GptIniData['General']['gPCUserExtensionNames'] -notlike "*$UserGpoScriptExtensions*")
        {
            $GptIniData['General']['gPCUserExtensionNames'] += "[$UserGpoScriptExtensions]"
        }

        # psscripts.ini
        $PSScriptsIniContent = Get-Content -Raw -Path $UserGpoPSScriptsIniFilePath -ErrorAction 'SilentlyContinue'
        $PSScriptsIniData = ConvertFrom-Ini -InputObject $PSScriptsIniContent

        $PSScriptCount = $PSScriptsIniData["$Type"].Count / 2
        $PSScriptsIniData["$Type"] += [ordered]@{
            "${PSScriptCount}CmdLine"    = $FilePath
            "${PSScriptCount}Parameters" = $Parameter
        }

        # write files
        $GptIniData | ConvertTo-Ini | Out-File -FilePath $GptIniFilePath -Force
        (Get-ItemProperty -Path $GptIniFilePath).Attributes = 'Normal'

        if (Test-Path -Path $UserGpoScriptsIniFilePath)
        {
            (Get-ItemProperty -Path $UserGpoPSScriptsIniFilePath).Attributes = 'Normal'
        }
        $PSScriptsIniData | ConvertTo-Ini | Out-File -FilePath $UserGpoPSScriptsIniFilePath -Encoding 'Unicode'
        (Get-ItemProperty -Path $UserGpoPSScriptsIniFilePath).Attributes = 'Hidden'

        if (-not (Test-Path -Path $UserGpoScriptsIniFilePath))
        {
            '' | Out-File -FilePath $UserGpoScriptsIniFilePath -Encoding 'Unicode'
            (Get-ItemProperty -Path $UserGpoScriptsIniFilePath).Attributes = 'Hidden'
        }

        # apply group policy script (generate registry entries)
        gpupdate.exe /Force /Target:User | Out-Null
    }
}
