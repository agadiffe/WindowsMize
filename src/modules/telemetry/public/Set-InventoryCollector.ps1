#=================================================================================================================
#                                         Telemetry - Inventory Collector
#=================================================================================================================

# This setting will prevent the Program Inventory from collecting data about
# a system and sending the information to Microsoft.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-InventoryCollector
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-InventoryCollector
{
    <#
    .EXAMPLE
        PS> Set-InventoryCollector -GPO 'Disabled'
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

        # gpo\ computer config > administrative tpl > windows components > application compatibility
        #   turn off application telemetry
        #   turn off inventory collector
        # not configured: delete (default) | on: 0 1
        $InventoryCollectorGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\AppCompat'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'AITEnable'
                    Value = '0'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableInventory'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Inventory Collector (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $InventoryCollectorGpo
    }
}
