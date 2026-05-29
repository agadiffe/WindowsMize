#=================================================================================================================
#                  Personnalization > Start > Show Recent Items In Jump Lists And File Explorer
#=================================================================================================================

# old wording:
#   Show recently opened items In Start, Jump Lists, And File Explorer
#   Show recommended files in Start, recent files in File Explorer, and items in Jump Lists

<#
.SYNTAX
    Set-StartShowRecentItems
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartShowRecentItems
{
    <#
    .EXAMPLE
        PS> Set-StartShowRecentItems -State 'Disabled' -GPO 'NotConfigured'
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
        $RecentItemsMsg = 'Start - Show Recent Items In Jump Lists And File Explorer'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $StartRecentItems = @{
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

                Write-Verbose -Message "Setting '$RecentItemsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StartRecentItems
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   do not keep history of recently opened documents
                # not configured: delete (default) | off: 1
                $StartRecentItemsGpo = @{
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

                Write-Verbose -Message "Setting '$RecentItemsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $StartRecentItemsGpo
            }
        }
    }
}
