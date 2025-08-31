#=================================================================================================================
#                                          Windows Update Search Drivers
#=================================================================================================================

# See also Set-ManufacturerAppsAutoDownload in System Properties script.

<#
.SYNTAX
    Set-WindowsUpdateSearchDrivers
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WindowsUpdateSearchDrivers
{
    <#
    .EXAMPLE
        PS> Set-WindowsUpdateSearchDrivers -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > system > device installation
        #   specify search order for device driver source location
        # not configured: delete (default)
        # on: do not search Windows Update (0), always search Windows Update (1), search Windows Update only if needed (2)
        #
        # gpo\ computer config > administrative tpl > windows components > windows update > manage updates offered from windows update
        #   do not include drivers with Windows updates
        # not configured: delete (default) | on: 1
        $WindowsUpdateSearchDriversGpo = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Windows\DriverSearching'
                Entries = @(
                    @{
                        RemoveEntry = $GPO -eq 'NotConfigured'
                        Name  = 'SearchOrderConfig'
                        Value = $GPO -eq 'Enabled' ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
                Entries = @(
                    @{
                        RemoveEntry = $GPO -ne 'Disabled'
                        Name  = 'ExcludeWUDriversInQualityUpdate'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Windows Update Search Drivers (GPO)' to '$GPO' ..."
        $WindowsUpdateSearchDriversGpo | Set-RegistryEntry
    }
}
