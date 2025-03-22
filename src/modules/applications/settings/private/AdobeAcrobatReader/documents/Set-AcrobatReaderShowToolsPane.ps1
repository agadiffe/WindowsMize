#=================================================================================================================
#                           Acrobat Reader - Preferences > Documents > Show Tools Pane
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderShowToolsPane
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderShowToolsPane
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderShowToolsPane -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # remember current state of Tools Pane
        # on: 1 | off: 0 (default)
        #
        # Tools Pane state
        # If 'bRHPSticky' is enabled, it reads the state from this entry.
        # on: 4 (default) | off: 3
        $AcrobatReaderShowToolsPane = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
            Entries = @(
                @{
                    Name  = 'bRHPSticky'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'iAV2ViewerAllToolsState'
                    Value = $State -eq 'Enabled' ? '4' : '3'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Show Tools Pane' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderShowToolsPane
    }
}
