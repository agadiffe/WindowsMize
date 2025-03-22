#=================================================================================================================
#                         Acrobat Reader - Preferences > Javascript > Acrobat Javascript
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderJavascript
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderJavascript
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderJavascript -State 'Disabled'
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
        $AcrobatReaderJavascript = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\JSPrefs'
            Entries = @(
                @{
                    Name  = 'bEnableJS'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Javascript' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderJavascript
    }
}
