#=================================================================================================================
#                      Apps > Apps For Websites > Open Links In An App Instead Of A Browser
#=================================================================================================================

<#
.SYNTAX
    Set-AppsOpenLinksInsteadOfBrowser
        [[-GPO] {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppsOpenLinksInsteadOfBrowser
{
    <#
    .EXAMPLE
        PS> Set-AppsOpenLinksInsteadOfBrowser -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > system > group policy
        #   configure web-to-app linking with app URL handlers
        # not configured: delete (default) | off: 0
        $OpenLinksInAppGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EnableAppUriHandlers'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Offline Maps - Metered Connection' to '$GPO' ..."
        Set-RegistryEntry -InputObject $OpenLinksInAppGpo
    }
}
