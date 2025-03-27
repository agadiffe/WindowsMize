#=================================================================================================================
#                                  Personnalization > Lock Screen > Your Widgets
#=================================================================================================================

<#
.SYNTAX
    Set-LockScreenYourWidgets
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-LockScreenYourWidgets
{
    <#
    .EXAMPLE
        PS> Set-LockScreenYourWidgets -State 'Disabled' -GPO 'NotConfigured'
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
        $YourWidgetsMsg = 'Lock Screen - Your Widgets'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $LockScreenYourWidgets = @{
                    Hive    = 'HKEY_CURRENT_USER\'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Lock Screen'
                    Entries = @(
                        @{
                            Name  = 'LockScreenWidgetsEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$YourWidgetsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $LockScreenYourWidgets
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > widgets
                #   disable Widgets On Lock Screen
                # not configured: delete (default) | on: 0
                $LockScreenYourWidgetsGpo = @{
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

                Write-Verbose -Message "Setting '$YourWidgetsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $LockScreenYourWidgetsGpo
            }
        }
    }
}
