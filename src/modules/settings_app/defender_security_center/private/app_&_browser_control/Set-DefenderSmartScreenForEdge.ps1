#=================================================================================================================
#         Defender > App & Browser Control > Reputation-Based Protection > Smartscreen For Microsoft Edge
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderSmartScreenForEdge
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-DefenderSmartScreenForEdge
{
    <#
    .EXAMPLE
        PS> Set-DefenderSmartScreenForEdge -State 'Disabled' -GPO 'NotConfigured'
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
        $DefenderSmartScreenForEdgeMsg = 'Defender - Smartscreen For Microsoft Edge'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '1' : '0'

                # on: 1 0 1 (default) | off: 0 0 0
                $DefenderSmartScreenForEdge = @(
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter'
                        Entries = @(
                            @{
                                Name  = 'EnabledV9'
                                Value = $Value
                                Type  = 'DWord'
                            }
                            @{
                                Name  = 'PreventOverride'
                                Value = '0'
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Edge\SmartScreenEnabled'
                        Entries = @(
                            @{
                                Name  = '(Default)'
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$DefenderSmartScreenForEdgeMsg' to '$State' ..."
                $DefenderSmartScreenForEdge | Set-RegistryEntry
            }
            'GPO'
            {
                # gpo\ not configured: delete (default) | on: 1 | off: 0
                $DefenderSmartScreenForEdgeGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Edge'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'SmartScreenEnabled'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderSmartScreenForEdgeMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DefenderSmartScreenForEdgeGpo
            }
        }
    }
}
