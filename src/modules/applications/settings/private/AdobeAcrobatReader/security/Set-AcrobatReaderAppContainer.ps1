#=================================================================================================================
#                          Acrobat Reader - Preferences > Security > Run In AppContainer
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderAppContainer
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAppContainer
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAppContainer -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
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

        Write-Verbose -Message "Setting 'Acrobat Reader - Run In AppContainer' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderAppContainer
    }
}
