#=================================================================================================================
#       Accounts > Sign-In Options > Use My Sign-In Info To Automatically Finish Setting Up After An Update
#=================================================================================================================

<#
.SYNTAX
    Set-SigninAutoFinishSettingUpAfterUpdate
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SigninAutoFinishSettingUpAfterUpdate
{
    <#
    .EXAMPLE
        PS> Set-SigninAutoFinishSettingUpAfterUpdate -State 'Disabled' -GPO 'NotConfigured'
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
        $AutoSettingMsg = 'Sign-In Options - Use My Sign-In Info To Automatically Finish Setting Up After An Update'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $UserSid = (Get-LoggedOnUserInfo).Sid

                # on: 0 (default) | off: 1
                $SigninAutoSettingAfterUpdate = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$UserSid"
                    Entries = @(
                        @{
                            Name  = 'OptOut'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AutoSettingMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $SigninAutoSettingAfterUpdate
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > windows logon options
                #   sign-in and lock last interactive user automatically after a restart
                # not configured: delete (default) | on: 0 | off: 1
                $SigninAutoSettingAfterUpdateGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableAutomaticRestartSignOn'
                            Value = $GPO -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AutoSettingMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $SigninAutoSettingAfterUpdateGpo
            }
        }
    }
}
