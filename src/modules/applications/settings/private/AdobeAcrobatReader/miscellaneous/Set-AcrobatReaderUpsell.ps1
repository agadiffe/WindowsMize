#=================================================================================================================
#                       Acrobat Reader - Miscellaneous > Upsell (offers to buy extra tools)
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderUpsell
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderUpsell
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderUpsell -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: 0 1 (default) | off: 1 0
        $AcrobatReaderUpsell = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                Entries = @(
                    @{
                        Name  = 'bAcroSuppressUpsell'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\ArmUpsell'
                Entries = @(
                    @{
                        Name  = 'bIsEnabled'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Acrobat Reader - Upsell (offers to buy extra tools)' to '$State' ..."
        $AcrobatReaderUpsell | Set-RegistryEntry
    }
}
