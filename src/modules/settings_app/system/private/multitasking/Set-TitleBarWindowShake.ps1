#=================================================================================================================
#                                 System > Multitasking > Title Bar Window Shake
#=================================================================================================================

<#
.SYNTAX
    Set-TitleBarWindowShake
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-TitleBarWindowShake
{
    <#
    .EXAMPLE
        PS> Set-TitleBarWindowShake -State 'Disabled' -GPO 'NotConfigured'
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
        $TitleBarWindowShakeMsg = 'Multitasking - Title Bar Window Shake'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 0 | off: 1 (default)
                $TitleBarWindowShake = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'DisallowShaking'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TitleBarWindowShakeMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $TitleBarWindowShake
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > desktop
                #   turn off Aero shake window minimizing mouse gesture
                # not configured: delete (default) | on: 1
                $TitleBarWindowShakeGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoWindowMinimizingShortcuts'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TitleBarWindowShakeMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $TitleBarWindowShakeGpo
            }
        }
    }
}
