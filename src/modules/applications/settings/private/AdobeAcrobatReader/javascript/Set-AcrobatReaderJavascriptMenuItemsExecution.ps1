#=================================================================================================================
#          Acrobat Reader - Preferences > Javascript > Enable Menu Items Javascript Execution Privileges
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderJavascriptMenuItemsExecution
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderJavascriptMenuItemsExecution
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderJavascriptMenuItemsExecution -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $AcrobatReaderJavascriptMenuItemsExecution = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\JSPrefs'
            Entries = @(
                @{
                    Name  = 'bEnableMenuItems'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Menu Items Javascript Execution Privileges' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderJavascriptMenuItemsExecution
    }
}
