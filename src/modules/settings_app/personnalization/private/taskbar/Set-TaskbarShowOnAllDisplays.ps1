#=================================================================================================================
#                Personnalization > Taskbar > Taskbar Behaviors > Show My Taskbar On All Displays
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarShowOnAllDisplays
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-TaskbarShowOnAllDisplays
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowOnAllDisplays -State 'Enabled' -GPO 'NotConfigured'
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
        $TaskbarOnAllDisplaysMsg = 'Taskbar - Show My Taskbar On All Displays'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $TaskbarOnAllDisplays = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'MMTaskbarEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarOnAllDisplaysMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $TaskbarOnAllDisplays
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > start menu and taskbar
                #   do not allow taskbars on more than one display
                # not configured: delete (default) | on: 1
                $TaskbarOnAllDisplaysGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'TaskbarNoMultimon'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarOnAllDisplaysMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $TaskbarOnAllDisplaysGpo
            }
        }
    }
}
