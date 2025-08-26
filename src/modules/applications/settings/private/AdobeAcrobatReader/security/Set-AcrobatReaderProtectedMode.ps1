#=================================================================================================================
#                 Acrobat Reader - Preferences > Security (Enhanced) > Protected Mode At Startup
#=================================================================================================================

# GPO values:
#   Disabled: disable both "Protected Mode At Startup" and "Run In AppContainer".
#   Enabled : only enforce "Protected Mode At Startup".

<#
.SYNTAX
    Set-AcrobatReaderProtectedMode
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderProtectedMode
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderProtectedMode -State 'Enabled' -GPO 'NotConfigured'
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
        $ProtectedModeMsg = 'Acrobat Reader - Protected Mode At Startup'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AcrobatReaderProtectedMode = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\Privileged'
                    Entries = @(
                        @{
                            Name  = 'bProtectedMode'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ProtectedModeMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderProtectedMode
            }
            'GPO'
            {
                # gpo\ Privileged (Protected Mode) > Protected Mode
                #   enables Protected Mode which sandboxes Acrobat and Reader processes
                # not configured: delete (default) | on: 1 | off: 0
                $AcrobatReaderProtectedModeGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'bProtectedMode'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ProtectedModeMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderProtectedModeGpo
            }
        }
    }
}
