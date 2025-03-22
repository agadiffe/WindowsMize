#=================================================================================================================
#                                                   Wifi Sense
#=================================================================================================================

# Wifi Sense has been deprecated and removed from Windows 10 and 11.
# Windows do not automatically connect to free public hotspots anymore.
# This GPO is (probably) no longer functional. Doesn't hurt to disable it anyway.

<#
.SYNTAX
    Set-WifiSense
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WifiSense
{
    <#
    .EXAMPLE
        PS> Set-WifiSense -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > network > wlan service > wlan settings
        #   allow Windows to automatically connect to suggested open hotspots,
        #     to networks shared by contacts, and to hotspots offering paid services
        # not configured: delete (default) | off: 0
        $WifiSenseGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AutoConnectAllowedOEM'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Wifi Sense (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WifiSenseGpo
    }
}
