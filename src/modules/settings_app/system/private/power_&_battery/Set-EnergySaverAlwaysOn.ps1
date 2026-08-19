#=================================================================================================================
#                        System > Power & Battery > Energy Saver > Always Use Energy Saver
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverAlwaysOn
        [[-State] {Disabled | Enabled}]
        [-GPO {Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-EnergySaverAlwaysOn
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverAlwaysOn -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutDisabled] $GPO
    )

    process
    {
        $EnergySaverMsg = 'Energy Saver - Always Use Energy Saver'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 2 (default)
                $EnergySaver = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SYSTEM\CurrentControlSet\Control\Power'
                    Entries = @(
                        @{
                            Name  = 'EnergySaverState'
                            Value = $State -eq 'Enabled' ? '1' : '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$EnergySaverMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $EnergySaver
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > power management > energy saver settings
                #   enable energy saver to always be On
                # not configured: delete (default) | on: 1
                $EnergySaverGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Power\EnergySaver'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'EnableEnergySaver'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$EnergySaverMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $EnergySaverGpo
            }
        }
    }
}
