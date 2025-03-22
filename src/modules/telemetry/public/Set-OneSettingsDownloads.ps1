#=================================================================================================================
#                                        Telemetry - OneSettings Downloads
#=================================================================================================================

# Windows periodically attempts to connect with the OneSettings service to download
# and update various system configuration settings.
# The service collects and reports telemetry data back to Microsoft about OS health,
# build information, and other system-related data.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-OneSettingsDownloads
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-OneSettingsDownloads
{
    <#
    .EXAMPLE
        PS> Set-OneSettingsDownloads -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
        #   disable OneSettings downloads
        # not configured: delete (default) | on: 1
        $OneSettingsDownloadsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableOneSettingsDownloads'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'OneSettings Downloads (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $OneSettingsDownloadsGpo
    }
}
