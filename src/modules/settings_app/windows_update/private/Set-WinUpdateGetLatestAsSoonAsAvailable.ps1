#=================================================================================================================
#                      Windows Update > Get The Latest Updates As Soon As They Are Available
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateGetLatestAsSoonAsAvailable
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinUpdateGetLatestAsSoonAsAvailable
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateGetLatestAsSoonAsAvailable -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $WinUpdateGetLatestAsapMsg = 'Windows Update - Get The Latest Updates As Soon As They Are Available'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $WinUpdateGetLatestAsap = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
                    Entries = @(
                        @{
                            Name  = 'IsContinuousInnovationOptedIn'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateGetLatestAsapMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinUpdateGetLatestAsap
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'
                $IsEnabled = $GPO -eq 'Enabled'

                # gpo\ computer config > administrative tpl > windows components > windows update > manage updates offered from Windows Update
                #   enable optional updates
                # not configured: delete (default)
                # on (Automatically receive optional updates (including gradual feature rollouts (CFRs)): 1 1
                # off (Automatically receive optional updates): 2 1
                $WinUpdateGetLatestAsapGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'AllowOptionalContent'
                            Value = $IsEnabled ? '1' : '2'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'SetAllowOptionalContent'
                            Value = $IsEnabled ? '1' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateGetLatestAsapMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinUpdateGetLatestAsapGpo
            }
        }
    }
}
