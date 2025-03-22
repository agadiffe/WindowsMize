#=================================================================================================================
#                                    Accounts > Sign-In Options > Dynamic Lock
#=================================================================================================================

# Allow Windows to automatically lock your device when you're away

<#
.SYNTAX
    Set-SigninDynamicLock
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SigninDynamicLock
{
    <#
    .EXAMPLE
        PS> Set-SigninDynamicLock -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $DynamicLockMsg = 'Sign-In Options - Dynamic Lock'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 | off: 0 (default)
                $SigninDynamicLock = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
                    Entries = @(
                        @{
                            Name  = 'EnableGoodbye'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DynamicLockMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $SigninDynamicLock
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                $PluginsDefaultValue = '
                    <rule schemaVersion="1.0">
                        <signal type="bluetooth" scenario="Dynamic Lock" classOfDevice="512" rssiMin="-10" rssiMaxDelta="-10"/>
                    </rule>
                ' -replace '\s{2,}', ' '

                # gpo\ computer config > administrative tpl > windows components > windows hello for business
                #   configure dynamic lock factors
                # not configured: delete (default) | on: 1 PluginsValue | off: 0 delete
                $SigninDynamicLockGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\PassportForWork\DynamicLock'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'DynamicLock'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured -or $GPO -eq 'Disabled'
                            Name  = 'Plugins'
                            Value = $PluginsDefaultValue
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DynamicLockMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $SigninDynamicLockGpo
            }
        }
    }
}
