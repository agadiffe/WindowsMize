#=================================================================================================================
#                        Privacy & Security > Activity History > Store My Activity History
#=================================================================================================================

# Activity History | old
#   Store my activity history on this device
#   Store my activity history to Microsoft

<#
.SYNTAX
    Set-WinPermissionsActivityHistory
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsActivityHistory
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsActivityHistory -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $WinPermissionsActivityHistoryMsg = 'Windows Permissions - Activity History'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {

                $CDPUserSettingsFile = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\ConnectedDevicesPlatform\CDPGlobalSettings.cdp"
    
                if (Test-Path -Path $CDPUserSettingsFile)
                {
                    $CDPUserSettings = Get-Content -Raw -Path $CDPUserSettingsFile | ConvertFrom-Json -AsHashtable

                    # on: 0 (default) | off: 1
                    $Value = $State -eq 'Enabled' ? 0 : 1
                    $CDPUserSettings.AfcPrivacySettings.PublishUserActivity = $Value
                    $CDPUserSettings.AfcPrivacySettings.UploadUserActivity = $Value

                    Write-Verbose -Message "Setting '$WinPermissionsActivityHistoryMsg' to '$State' ..."
                    $CDPUserSettings | ConvertTo-Json -Depth 100 | Out-File -FilePath $CDPUserSettingsFile
                }
                else
                {
                    Write-Verbose -Message "Setting '$WinPermissionsActivityHistoryMsg': '$CDPUserSettingsFile' not found"
                }
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ computer config > administrative tpl > system > os policies
                #   enables activity feed
                #   allow publishing of user activities
                #   allow upload of user activities
                # not configured: delete (default) | off: 0 0 0
                $WinPermissionsActivityHistoryGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'EnableActivityFeed'
                            Value = '0'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'PublishUserActivities'
                            Value = '0'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'UploadUserActivities'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsActivityHistoryMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsActivityHistoryGpo
            }
        }
    }
}
