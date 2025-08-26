#=================================================================================================================
#                     Acrobat Reader - Miscellaneous > Upsell Mobile App (ads on Home banner)
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderUpsellMobileApp
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderUpsellMobileApp
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderUpsellMobileApp -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ Workflows (Services integration) > Upsell-DC Home Banner
        #   specifies whether to show the Acrobat mobile app promotion and link in the Home banner
        #   specifies whether to show the Adobe Scan mobile app promotion and link in the Home banner.
        # not configured: delete (default) | off: 1
        $AcrobatReaderUpsellMobileAppGpo = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\Workflows\cServices\cAcrobatApp'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bAcrobatAppInstalled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\Workflows\cServices\cScanApp'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bScanAppInstalled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Acrobat Reader - Upsell Mobile App (ads on Home banner) (GPO)' to '$GPO' ..."
        $AcrobatReaderUpsellMobileAppGpo | Set-RegistryEntry
    }
}
