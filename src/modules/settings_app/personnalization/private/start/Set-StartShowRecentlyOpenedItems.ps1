#=================================================================================================================
#          Personnalization > Start > Show Recently Opened Items In Start, Jump Lists, And File Explorer
#=================================================================================================================

# Show recommended files in Start, recent files in File Explorer, and items in Jump Lists

<#
.SYNTAX
    Set-StartShowRecentlyOpenedItems
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartShowRecentlyOpenedItems
{
    <#
    .EXAMPLE
        PS> Set-StartShowRecentlyOpenedItems -State 'Disabled' -GPO 'NotConfigured'
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
        $RecentlyOpenedItemsMsg = 'Start - Show Recently Opened Items In Start, Jump Lists, And File Explorer'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $StartRecentlyOpenedItems = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'Start_TrackDocs'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecentlyOpenedItemsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StartRecentlyOpenedItems
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   do not keep history of recently opened documents
                # not configured: delete (default) | off: 1
                $StartRecentlyOpenedItemsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoRecentDocsHistory'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RecentlyOpenedItemsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StartRecentlyOpenedItemsGpo
            }
        }
    }
}
