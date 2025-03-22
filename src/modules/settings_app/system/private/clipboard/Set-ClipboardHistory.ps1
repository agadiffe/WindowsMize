#=================================================================================================================
#                                     System > Clipboard > Clipboard History
#=================================================================================================================

<#
.SYNTAX
    Set-ClipboardHistory
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-ClipboardHistory
{
    <#
    .EXAMPLE
        PS> Set-ClipboardHistory -State 'Disabled' -GPO 'NotConfigured'
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
        $ClipboardHistoryMsg = 'Clipboard History'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $ClipboardHistory = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Clipboard'
                    Entries = @(
                        @{
                            Name  = 'EnableClipboardHistory'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ClipboardHistoryMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $ClipboardHistory
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > OS policies
                #   allow clipboard history
                # not configured: delete (default) | on: 1 | off: 0
                $ClipboardHistoryGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowClipboardHistory'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ClipboardHistoryMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $ClipboardHistoryGpo
            }
        }
    }
}
