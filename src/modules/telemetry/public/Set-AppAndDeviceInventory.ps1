#=================================================================================================================
#                                      Telemetry - App and Device Inventory
#=================================================================================================================

# Application compatibility related.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-AppAndDeviceInventory
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AppAndDeviceInventory
{
    <#
    .EXAMPLE
        PS> Set-AppAndDeviceInventory -GPO 'Disabled'
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

        # gpo\ computer config > administrative tpl > windows components > app and device inventory
        #   turn off API sampling
        #   turn off application footprint
        #   turn off compatibility scan for backed up applications
        #   turn off install tracing
        # not configured: delete (default) | on: 1
        $AppAndDeviceInventoryGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\AppCompat'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableAPISamping'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableApplicationFootprint'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableWin32AppBackup'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableInstallTracing'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'App and Device Inventory (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AppAndDeviceInventoryGpo
    }
}
