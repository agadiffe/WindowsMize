#=================================================================================================================
#                                 Privacy & Security > Click To Do > Click To Do
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsClickToDo
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsClickToDo
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsClickToDo -State 'Disabled' -GPO 'NotConfigured'
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
        $WinPermissionsClickToDoMsg = 'Windows Permissions - Click To Do'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsClickToDo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\Shell\ClickToDo'
                    Entries = @(
                        @{
                            Name  = 'DisableClickToDo'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsClickToDoMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsClickToDo
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > windows AI
                #   disable Click to Do
                # not configured: delete (default) | on: 1
                $WinPermissionsClickToDoGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableClickToDo'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsClickToDoMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsClickToDoGpo
            }
        }
    }
}
