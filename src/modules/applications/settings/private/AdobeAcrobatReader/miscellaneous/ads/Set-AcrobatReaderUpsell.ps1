#=================================================================================================================
#                        Acrobat Reader - Miscellaneous > Upsell (ads to buy extra tools)
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderUpsell
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderUpsell
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderUpsell -GPO 'Disabled'
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

        # gpo\ FeatureLockDown (Lockable Settings) > Upsell (Acrobat Reader)
        #   disables messages which encourage the user to upgrade the product
        # not configured: delete (default) | off: 1
        #
        # gpo\ FeatureLockDown (Lockable Settings) > Upsell (Acrobat)
        #   specifies whether to show users messages which promote (Trials, Acrobat, PDF Pack etc.)
        # not configured: delete (default) | off: 0
        $AcrobatReaderUpsellGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'bAcroSuppressUpsell'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'bToggleSophiaWebInfra'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Upsell (ads to buy extra tools) (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderUpsellGpo
    }
}
