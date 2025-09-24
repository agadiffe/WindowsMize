#=================================================================================================================
#                                                 New GPO Script
#=================================================================================================================

<#
.SYNTAX
    New-GpoScript
        [-FilePath] <string>
        [-Type] {Logon | Logoff}
        [<CommonParameters>]
#>

function New-GpoScript
{
    <#
    .EXAMPLE
        PS> New-GpoScript -FilePath 'C:\MyScript.ps1' -Type 'Logoff'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [ValidateSet('Logon', 'Logoff')]
        [string] $Type
    )

    process
    {
        $UserSid = (Get-LoggedOnUserInfo).Sid
        $GpoScriptRegPath = "HKEY_USERS\$UserSid\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$Type\0"
        $ScriptNumber = (Get-ChildItem -Path "Registry::$GpoScriptRegPath" -ErrorAction 'SilentlyContinue').Count

        $GpoScript = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = "Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$Type\0"
                Entries = @(
                    @{
                        Name  = 'DisplayName'
                        Value = 'Local Group Policy'
                        Type  = 'String'
                    }
                    @{
                        Name  = 'FileSysPath'
                        Value = "$env:SystemRoot\System32\GroupPolicy\User"
                        Type  = 'String'
                    }
                    @{
                        Name  = 'GPO-ID'
                        Value = 'LocalGPO'
                        Type  = 'String'
                    }
                    @{
                        Name  = 'GPOName'
                        Value = 'Local Group Policy'
                        Type  = 'String'
                    }
                    @{
                        Name  = 'PSScriptOrder'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'SOM-ID'
                        Value = 'Local'
                        Type  = 'String'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = "Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$Type\0\$ScriptNumber"
                Entries = @(
                    @{
                        Name  = 'ExecTime'
                        Value = '0'
                        Type  = 'QWord'
                    }
                    @{
                        Name  = 'IsPowershell'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'Parameters'
                        Value = ''
                        Type  = 'String'
                    }
                    @{
                        Name  = 'Script'
                        Value = $FilePath
                        Type  = 'String'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$UserSid\Scripts\$Type\0"
                Entries = $null
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\$UserSid\Scripts\$Type\0\$ScriptNumber"
                Entries = $null
            }
        )

        $GpoScript[2].Entries = $GpoScript[0].Entries
        $GpoScript[3].Entries = $GpoScript[1].Entries | Where-Object -Property 'Name' -NE -Value 'IsPowershell'

        # These directories must exist for the GPO User scripts to work.
        $GroupPolicyScriptDirectories = @(
            "$env:SystemRoot\System32\GroupPolicy\User\Scripts\Logon"
            "$env:SystemRoot\System32\GroupPolicy\User\Scripts\Logoff"
        )
        foreach ($Directory in $GroupPolicyScriptDirectories)
        {
            if (-not (Test-Path -Path $Directory))
            {
                New-Item -ItemType 'Directory' -Path $Directory | Out-Null
            }
        }

        $GpoScript | Set-RegistryEntry -Verbose:$false
    }
}
