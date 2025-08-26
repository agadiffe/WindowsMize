#=================================================================================================================
#          Acrobat Reader - Preferences > Javascript > Enable Global Object Security Policy
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderJavascriptGlobalObjectSecurity
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderJavascriptGlobalObjectSecurity
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderJavascriptGlobalObjectSecurity -State 'Disabled'
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
        $AcrobatReaderJavascriptGlobalObjectSecurity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\JSPrefs'
            Entries = @(
                @{
                    Name  = 'bEnableGlobalSecurity'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Global Object Security Policy' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderJavascriptGlobalObjectSecurity
    }
}
