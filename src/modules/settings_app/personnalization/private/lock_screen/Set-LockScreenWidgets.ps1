#=================================================================================================================
#                                  Personnalization > Lock Screen > Your Widgets
#=================================================================================================================

<#
.SYNTAX
    Set-LockScreenWidgets
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-LockScreenWidgets
{
    <#
    .EXAMPLE
        PS> Set-LockScreenWidgets -State 'Disabled' -GPO 'NotConfigured'
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
        $WidgetsMsg = 'Lock Screen - Your Widgets'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $LockScreenWidgets = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Lock Screen'
                    Entries = @(
                        @{
                            Name  = 'LockScreenWidgetsEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WidgetsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $LockScreenWidgets
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > widgets
                #   disable Widgets On Lock Screen
                # not configured: delete (default) | on: 0
                $LockScreenWidgetsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Dsh'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableWidgetsOnLockScreen'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WidgetsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $LockScreenWidgetsGpo
            }
        }
    }
}
