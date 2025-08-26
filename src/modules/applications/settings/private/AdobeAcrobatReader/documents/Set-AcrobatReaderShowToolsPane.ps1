#=================================================================================================================
#                           Acrobat Reader - Preferences > Documents > Show Tools Pane
#=================================================================================================================

# The GUI have only this setting: Remember last state of the All tools pane when opening documents

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
        # bRHPSticky\ remember current state of All tools pane
        # on: 1 | off: 0 (default)
        #
        # All tools pane state
        # If 'bRHPSticky' is enabled, it reads the state from 'iAV2ViewerAllToolsState'.
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
