#=================================================================================================================
#                    Acrobat Reader - Preferences > Security (Enhanced) > Run In AppContainer
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderAppContainer
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderAppContainer
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAppContainer -State 'Enabled' -GPO 'NotConfigured'
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
        $AppContainerMsg = 'Acrobat Reader - Run In AppContainer'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AcrobatReaderAppContainer = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\Privileged'
                    Entries = @(
                        @{
                            Name  = 'bEnableProtectedModeAppContainer'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AppContainerMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderAppContainer
            }
            'GPO'
            {
                # gpo\ Privileged (Protected Mode) > AppContainer
                #   specifies whether to enable the AppContainer sandbox
                # not configured: delete (default) | on: 1 | off: 0
                $AcrobatReaderAppContainerGpo = @{
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

                Write-Verbose -Message "Setting '$AppContainerMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderAppContainerGpo
            }
        }
    }
}
