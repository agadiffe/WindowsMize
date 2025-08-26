#=================================================================================================================
#                                Acrobat Reader - Miscellaneous > Home Top Banner
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderHomeTopBanner
        [-GPO] {Disabled | Expanded | Collapsed}
        [<CommonParameters>]
#>

function Set-AcrobatReaderHomeTopBanner
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderHomeTopBanner -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AdobeHomeTopBannerMode] $GPO
    )

    process
    {
        # bEnableFirstMile\ on: 1 (default) | off: 0
        # bFirstMileMinimized\ expanded: 0 (default) | collapsed: 1
        $AcrobatReaderHomeTopBanner = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\HomeWelcomeFirstMile'
            Entries = @(
                @{
                    Name  = 'bEnableFirstMile'
                    Value = $GPO -eq 'Disabled' ? '0' : '1'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bFirstMileMinimized'
                    Value = [int]$GPO
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Home Top Banner' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderHomeTopBanner
    }
}
