#=================================================================================================================
#                       Personnalization > Start > Show Websites From Your Browsing History
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowWebsitesFromHistory
        [[-GPO] {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartShowWebsitesFromHistory
{
    <#
    .EXAMPLE
        PS> Set-StartShowWebsitesFromHistory -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > start menu and taskbar
        #   remove personalized website recommendations from the Recommended section in the Start Menu
        # not configured: delete (default) | off: 1
        $StartWebsitesFromHistoryGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'HideRecommendedPersonalizedSites'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show Websites From Your Browsing History (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $StartWebsitesFromHistoryGpo
    }
}
