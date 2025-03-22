#=================================================================================================================
#                       Privacy & Security > Diagnostics & Feedback > View Diagnostic Data
#=================================================================================================================

# Requires DiagTrack service running.

<#
.SYNTAX
    Set-WinPermissionsDiagnosticDataViewer
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsDiagnosticDataViewer
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsDiagnosticDataViewer -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsDiagnosticDataViewerMsg = 'Windows Permissions - Diagnostics & Feedback: View Diagnostic Data'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $WinPermissionsDiagnosticDataViewer = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey'
                    Entries = @(
                        @{
                            Name  = 'EnableEventTranscript'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsDiagnosticDataViewerMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsDiagnosticDataViewer
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
                #   disable diagnostic data viewer
                # not configured: delete (default) | on: 1
                $WinPermissionsDiagnosticDataViewerGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableDiagnosticDataViewer'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsDiagnosticDataViewerMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsDiagnosticDataViewerGpo
            }
        }
    }
}
