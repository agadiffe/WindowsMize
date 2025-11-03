#=================================================================================================================
#                             Personnalization > Taskbar > Taskbar Items > Task View
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarTaskView
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-TaskbarTaskView
{
    <#
    .EXAMPLE
        PS> Set-TaskbarTaskView -State 'Disabled' -GPO 'NotConfigured'
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
        $TaskbarTaskViewButtonMsg = 'Taskbar Items - Task View'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $TaskbarTaskViewButton = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'ShowTaskViewButton'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarTaskViewButtonMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $TaskbarTaskViewButton
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   hide the taskview button
                # not configured: delete (default) | on: 1
                $TaskbarTaskViewButtonGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'HideTaskViewButton'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarTaskViewButtonMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $TaskbarTaskViewButtonGpo
            }
        }
    }
}
