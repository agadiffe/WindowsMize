#=================================================================================================================
#                                    Apps > Offline Maps > Metered Connection
#=================================================================================================================

<#
.SYNTAX
    Set-OfflineMapsDownloadOverMeteredConnection
        [[-State] {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-OfflineMapsDownloadOverMeteredConnection
{
    <#
    .EXAMPLE
        PS> Set-OfflineMapsDownloadOverMeteredConnection -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 | off: 1 (default)
        $OfflineMapsMeteredConnection = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\Maps'
            Entries = @(
                @{
                    Name  = 'UpdateOnlyOnWifi'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Offline Maps - Metered Connection' to '$State' ..."
        Set-RegistryEntry -InputObject $OfflineMapsMeteredConnection
    }
}
