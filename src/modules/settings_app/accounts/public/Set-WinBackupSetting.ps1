#=================================================================================================================
#                                       Accounts > Window Backup - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-WinBackupSetting
        [-RememberAppsAndPrefsGPO {DefaultOff | Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinBackupSetting
{
    <#
    .EXAMPLE
        PS> Set-WinBackupSetting -RememberAppsAndPrefsGPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [RememberAppsAndPrefsMode] $RememberAppsAndPrefsGPO
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'RememberAppsAndPrefsGPO' { Set-WinBackupRememberAppsAndPrefs -GPO $RememberAppsAndPrefsGPO }
        }
    }
}
