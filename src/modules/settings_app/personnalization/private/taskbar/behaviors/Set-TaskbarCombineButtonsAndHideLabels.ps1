#=================================================================================================================
#            Personnalization > Taskbar > Taskbar Behaviors > Combine Taskbar Buttons And Hide Labels
#=================================================================================================================

# Combine taskbar buttons and hide labels
# Combine taskbar buttons and hide labels on other taskbars

<#
.SYNTAX
    Set-TaskbarCombineButtonsAndHideLabels
        [[-MainTaskbar] {Always | WhenTaskbarIsFull | Never}]
        [-OtherTaskbars {Always | WhenTaskbarIsFull | Never}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-TaskbarCombineButtonsAndHideLabels
{
    <#
    .EXAMPLE
        PS> Set-TaskbarCombineButtonsAndHideLabels -MainTaskbar 'Always' -OtherTaskbars 'Always'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [TaskbarGroupingMode] $MainTaskbar,

        [TaskbarGroupingMode] $OtherTaskbars,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $TaskbarGroupingItemsMsg = 'Taskbar - Combine Taskbar Buttons And Hide Labels'

        switch ($PSBoundParameters.Keys)
        {
            'MainTaskbar'
            {
                # always: 0 (default) | when taskbar is full: 1 | never: 2
                $TaskbarGroupingItems = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'TaskbarGlomLevel'
                            Value = [int]$MainTaskbar
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarGroupingItemsMsg' to '$MainTaskbar' ..."
                Set-RegistryEntry -InputObject $TaskbarGroupingItems
            }
            'OtherTaskbars'
            {
                # always: 0 (default) | when taskbar is full: 1 | never: 2
                $TaskbarGroupingItemsOnOtherTaskbars = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'MMTaskbarGlomLevel'
                            Value = [int]$OtherTaskbars
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarGroupingItemsMsg On Other Taskbars' to '$OtherTaskbars' ..."
                Set-RegistryEntry -InputObject $TaskbarGroupingItemsOnOtherTaskbars
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > start menu and taskbar
                #   prevent grouping of taskbar items
                # not configured: delete (default) | on: 1
                $TaskbarGroupingItemsGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoTaskGrouping'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarGroupingItemsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $TaskbarGroupingItemsGpo
            }
        }
    }
}
