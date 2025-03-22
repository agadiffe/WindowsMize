#=================================================================================================================
#                          Privacy & Security > Diagnostics & Feedback > Diagnostic Data
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsDiagnosticData
        [[-State] {Disabled | OnlyRequired | OptionalAndRequired}]
        [-GPO {Disabled | OnlyRequired | OptionalAndRequired | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsDiagnosticData
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsDiagnosticData -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [DiagnosticDataMode] $State,

        [GpoDiagnosticDataMode] $GPO
    )

    process
    {
        $WinPermissionsDiagnosticDataMsg = 'Windows Permissions - Diagnostics & Feedback: Diagnostic Data'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # send optional diagnostic data: 3 3 3 (default) | only send required diagnostic data: 1 1 1
                # off: 0 0 0 (only supported on Enterprise, Education, and Server editions) (No GUI toggle)
                $WinPermissionsDiagnosticData = @(
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack'
                        Entries = @(
                            @{
                                Name  = 'ShowedToastAtLevel'
                                Value = [int]$State
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'
                        Entries = @(
                            @{
                                Name  = 'AllowTelemetry'
                                Value = [int]$State
                                Type  = 'DWord'
                            }
                            @{
                                Name  = 'MaxTelemetryAllowed'
                                Value = [int]$State
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$WinPermissionsDiagnosticDataMsg' to '$State' ..."
                $WinPermissionsDiagnosticData | Set-RegistryEntry
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
                #   allow diagnostic data
                # not configured: delete (default)
                # send optional diagnostic data: 3 (default) | only send required diagnostic data: 1
                # off: 0 (only supported on Enterprise, Education, and Server editions)
                $WinPermissionsDiagnosticDataGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowTelemetry'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsDiagnosticDataMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsDiagnosticDataGpo
            }
        }
    }
}
