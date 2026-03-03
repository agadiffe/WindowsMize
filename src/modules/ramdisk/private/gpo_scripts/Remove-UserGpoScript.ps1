#=================================================================================================================
#                                             Remove User GPO Script
#=================================================================================================================

<#
.SYNTAX
    Remove-UserGpoScript
        [-FilePath] <string>
        [[-Parameter] <string>]
        [-Type] {Logon | Logoff}
        [<CommonParameters>]
#>

function Remove-UserGpoScript
{
    <#
    .EXAMPLE
        PS> Remove-UserGpoScript -FilePath 'C:\MyScript.ps1' -Type 'Logoff'
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
        $UserGpoPSScriptsIniFilePath = "$UserGpoScriptsPath\psscripts.ini"

        $PSScriptsIniContent = Get-Content -Raw -Path $UserGpoPSScriptsIniFilePath -ErrorAction 'SilentlyContinue'
        $PSScriptsIniData = ConvertFrom-Ini -InputObject $PSScriptsIniContent

        if ($PSScriptsIniData["$Type"])
        {
            $CmdLineKey = ($PSScriptsIniData["$Type"].GetEnumerator() | Where-Object -Property 'Value' -EQ -Value $FilePath).Name

            if ($CmdLineKey)
            {
                $ScriptNumber = $CmdLineKey[0]

                $ParamKey = ($PSScriptsIniData["$Type"].GetEnumerator() | Where-Object -FilterScript {
                    $_.Key[0] -eq $ScriptNumber -and $_.Value -eq $Parameter
                }).Name

                if ($ParamKey)
                {
                    $PSScriptsIniData["$Type"].Remove($CmdLineKey)
                    $PSScriptsIniData["$Type"].Remove($ParamKey)

                    $NewTypeData = [ordered]@{}
                    foreach ($Key in $PSScriptsIniData["$Type"].Keys)
                    {
                        $CurrentScriptNumber = $Key[0]
                        if ($CurrentScriptNumber -gt $ScriptNumber)
                        {
                            $NewKey = $Key -replace '^.', "$([int]"$CurrentScriptNumber" - 1)"
                            $NewTypeData[$NewKey] = $PSScriptsIniData["$Type"][$Key]
                        }
                        else
                        {
                            $NewTypeData[$Key] = $PSScriptsIniData["$Type"][$Key]
                        }
                    }
                    $PSScriptsIniData["$Type"] = $NewTypeData

                    (Get-ItemProperty -Path $UserGpoPSScriptsIniFilePath).Attributes = 'Normal'
                    $PSScriptsIniData | ConvertTo-Ini | Out-File -FilePath $UserGpoPSScriptsIniFilePath -Encoding 'Unicode'
                    (Get-ItemProperty -Path $UserGpoPSScriptsIniFilePath).Attributes = 'Hidden'

                    gpupdate.exe /Force /Target:User | Out-Null
                }
            }
        }
    }
}
