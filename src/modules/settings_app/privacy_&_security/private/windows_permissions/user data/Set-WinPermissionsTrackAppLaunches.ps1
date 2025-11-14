#=================================================================================================================
#               Privacy & Security > Recommendations And Offers > Improve Start And Search Results
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsTrackAppLaunches
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsTrackAppLaunches
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsTrackAppLaunches -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsTrackAppLaunchesMsg = 'Windows Permissions - Improve Start And Search Results'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsTrackAppLaunches = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'Start_TrackProgs'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsTrackAppLaunchesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsTrackAppLaunches
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > edge UI
                #   turn off tracking of app usage
                # not configured: delete (default) | on: 1
                $WinPermissionsTrackAppLaunchesGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\EdgeUI'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableMFUTracking'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsTrackAppLaunchesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsTrackAppLaunchesGpo
            }
        }
    }
}
