#=================================================================================================================
#        Accounts > Sign-In Options > Show Account Details Such As My Email Address On The Sign-In Screen
#=================================================================================================================

<#
.SYNTAX
    Set-SigninShowAccountDetails
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-SigninShowAccountDetails
{
    <#
    .EXAMPLE
        PS> Set-SigninShowAccountDetails -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $ShowAccountDetailsMsg = 'Sign-In Options - Show Account Details Such As My Email Address On The Sign-In Screen'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # not used.

                # owner: SYSTEM | full control: SYSTEM
                # Requested registry access is not allowed.

                $UserSid = (Get-LoggedOnUserInfo).Sid

                # on: 1 | off: 0 (default)
                $SigninShowAccountDetails = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\$UserSid\AnyoneRead\Logon"
                    Entries = @(
                        @{
                            Name  = 'ShowEmail'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ShowAccountDetailsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $SigninShowAccountDetails
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > logon
                #   block user from showing account details on sign-in
                # not configured: delete (default) | on: 1
                $SigninShowAccountDetailsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'BlockUserFromShowingAccountDetailsOnSignin'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ShowAccountDetailsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $SigninShowAccountDetailsGpo
            }
        }
    }
}
