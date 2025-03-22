#=================================================================================================================
#                           System Properties - Hardware > Device Installation Settings
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)
# See also: tweaks_misc > drivers

# Choose whether Windows downloads manufacters' apps and custom icons available for your devices.

# default: Enabled
# STIG recommendation: Disabled

<#
.SYNTAX
    Set-ManufacturerAppsAutoDownload
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-ManufacturerAppsAutoDownload
{
    <#
    .EXAMPLE
        PS> Set-ManufacturerAppsAutoDownload -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $ManufacturerAppsAutoDownloadMsg = 'Manufacturer Apps Auto Download'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 0 (default) | off: 1
                $ManufacturerAppsAutoDownload = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata'
                    Entries = @(
                        @{
                            Name  = 'PreventDeviceMetadataFromNetwork'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ManufacturerAppsAutoDownloadMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $ManufacturerAppsAutoDownload
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > device installation
                #   prevent device metadata retrieval from the Internet
                # not configured: delete (default) | on: 1
                $ManufacturerAppsAutoDownloadGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Device Metadata'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'PreventDeviceMetadataFromNetwork'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ManufacturerAppsAutoDownloadMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $ManufacturerAppsAutoDownloadGpo
            }
        }
    }
}
