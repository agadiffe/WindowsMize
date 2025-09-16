#=================================================================================================================
#                  Privacy & Security > General > Show Me Suggested Content In The Settings App
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsShowAdsInSettingsApp
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsShowAdsInSettingsApp
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsShowAdsInSettingsApp -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsTipsInSettingsAppMsg = 'Windows Permissions - Show Me Suggested Content In The Settings App'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '1' : '0'

                # on: 1 1 1 (default) | off: 0 0 0
                $WinPermissionsTipsInSettingsApp = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
                    Entries = @(
                        @{
                            Name  = 'SubscribedContent-338393Enabled'
                            Value = $Value
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'SubscribedContent-353694Enabled'
                            Value = $Value
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'SubscribedContent-353696Enabled'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsTipsInSettingsAppMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsTipsInSettingsApp
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > cloud content
                #   turn off Windows spotlight on Settings
                # not configured: delete (default) | on: 1
                $WinPermissionsTipsInSettingsAppGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableWindowsSpotlightOnSettings'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsTipsInSettingsAppMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsTipsInSettingsAppGpo
            }
        }
    }
}
