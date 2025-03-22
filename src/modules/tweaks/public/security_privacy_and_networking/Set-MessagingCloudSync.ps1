#=================================================================================================================
#                                              Messaging Cloud Sync
#=================================================================================================================

# Allows backup and restore of cellular text messages to Microsoft's cloud services.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-MessagingCloudSync
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MessagingCloudSync
{
    <#
    .EXAMPLE
        PS> Set-MessagingCloudSync -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > messaging
        #   allow message service cloud sync
        # not configured: delete (default) | off: 0
        $MessagingCloudSyncGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Messaging'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowMessageSync'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Messaging Cloud Sync (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MessagingCloudSyncGpo
    }
}
