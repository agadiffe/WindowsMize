#=================================================================================================================
#                        Acrobat Reader - Preferences > Security > Trust OS Trusted Sites
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTrustOSTrustedSites
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderTrustOSTrustedSites
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTrustOSTrustedSites -State 'Disabled'
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
        $AcrobatReaderTrustOSTrustedSites = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
            Entries = @(
                @{
                    Name  = 'bTrustOSTrustedSites'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Auto Trust Sites From My Win OS Security Zones' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderTrustOSTrustedSites
    }
}
