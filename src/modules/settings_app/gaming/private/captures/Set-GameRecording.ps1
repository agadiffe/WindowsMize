#=================================================================================================================
#                             Gaming > Captures > Recording Preferences (aka GameDVR)
#=================================================================================================================

<#
.SYNTAX
    Set-GameRecording
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-GameRecording
{
    <#
    .EXAMPLE
        PS> Set-GameRecording -State 'Disabled' -GPO 'NotConfigured'
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
        $GameDvrMsg = 'Gaming Captures - Recording Preferences (GameDVR)'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '1' : '0'

                # on: 1 1 1 (default) | off: 0 0 0
                $GameDvr = @(
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Windows\CurrentVersion\GameDVR'
                        Entries = @(
                            @{
                                Name  = 'AppCaptureEnabled'
                                Value = $Value
                                Type  = 'DWord'
                            }
                            @{
                                Name  = 'HistoricalCaptureEnabled' # 'Record What Happened' GUI toggle
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'System\GameConfigStore'
                        Entries = @(
                            @{
                                Name  = 'GameDVR_Enabled'
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$GameDvrMsg' to '$State' ..."
                $GameDvr | Set-RegistryEntry
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > windows game recording and broadcasting
                #   enables or disables Windows game recording and broadcasting
                # not configured: delete (default) | off: 0
                $GameDvrGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\GameDVR'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowgameDVR'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$GameDvrMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $GameDvrGpo
            }
        }
    }
}
