#=================================================================================================================
#                                                  Apps > Resume
#=================================================================================================================

<#
.SYNTAX
    Set-AppsResume
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppsResume
{
    <#
    .EXAMPLE
        PS> Set-AppsResume -State 'Disabled' -GPO 'NotConfigured'
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
        $AppsResumeMsg = 'Apps Resume'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AppsResume = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\CrossDeviceResume\Configuration'
                    Entries = @(
                        @{
                            Name  = 'IsResumeAllowed'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AppsResumeMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AppsResume
            }
            'GPO'
            {
                # gpo\ not configured: 0 (default) | off: 1
                $AppsResumeGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\PolicyManager\default\Connectivity\DisableCrossDeviceResume'
                    Entries = @(
                        @{
                            Name  = 'value'
                            Value = $GPO -eq 'Disabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AppsResumeMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AppsResumeGpo
            }
        }
    }
}
