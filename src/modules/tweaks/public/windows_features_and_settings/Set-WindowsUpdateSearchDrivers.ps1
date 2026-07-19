#=================================================================================================================
#                                          Windows Update Search Drivers
#=================================================================================================================

# See also Set-ManufacturerAppsAutoDownload in System Properties script.

<#
.SYNTAX
    Set-WindowsUpdateSearchDrivers
        [-GPO] {Disabled | NotConfigured}
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
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > windows update > manage updates offered from windows update
        #   do not include drivers with Windows updates
        # not configured: delete (default) | on: 1
        $WindowsUpdateSearchDriversGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'ExcludeWUDriversInQualityUpdate'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Update Search Drivers (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsUpdateSearchDriversGpo
    }
}
