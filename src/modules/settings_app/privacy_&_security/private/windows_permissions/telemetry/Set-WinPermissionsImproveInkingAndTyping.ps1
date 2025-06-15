#=================================================================================================================
#                     Privacy & Security > Diagnostics & Feedback > Improve Inking And Typing
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsImproveInkingAndTyping
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsImproveInkingAndTyping
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsImproveInkingAndTyping -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsImproveInkingAndTypingMsg = 'Windows Permissions - Diagnostics & Feedback: Improve Inking And Typing'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsImproveInkingAndTyping = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Input\TIPC'
                    Entries = @(
                        @{
                            Name  = 'Enabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsImproveInkingAndTypingMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsImproveInkingAndTyping
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > text input
                #   improve inking and typing recognition
                # not configured: delete (default) | off: 0
                $WinPermissionsImproveInkingAndTypingGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowLinguisticDataCollection'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsImproveInkingAndTypingMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsImproveInkingAndTypingGpo
            }
        }
    }
}
