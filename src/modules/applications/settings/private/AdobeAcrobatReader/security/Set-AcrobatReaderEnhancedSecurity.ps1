#=================================================================================================================
#                           Acrobat Reader - Preferences > Security > Enhanced Security
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderEnhancedSecurity
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderEnhancedSecurity
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderEnhancedSecurity -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $AcrobatReaderEnhancedSecurity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
            Entries = @(
                @{
                    Name  = 'bEnhancedSecurityInBrowser'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bEnhancedSecurityStandalone'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Enhanced Security' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderEnhancedSecurity
    }
}
