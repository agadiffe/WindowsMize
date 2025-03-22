#=================================================================================================================
#         Personnalization > Lock Screen > Show The Lock Screen Background Picture On The Sign-In Screen
#=================================================================================================================

<#
.SYNTAX
    Set-LockScreenShowPictureOnSigninScreen
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-LockScreenShowPictureOnSigninScreen
{
    <#
    .EXAMPLE
        PS> Set-LockScreenShowPictureOnSigninScreen -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $BackgroundPictureMsg = 'Lock Screen - Show The Lock Screen Background Picture On The Sign-In Screen'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # not used.

                # owner: SYSTEM | full control: SYSTEM
                # Requested registry access is not allowed.
                
                $UserSid = Get-LoggedOnUserSID

                # on: 0 (default) | off: 1
                $LockScreenBackgroundPictureOnSigninScreen = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\$UserSid\AnyoneRead\LockScreen"
                    Entries = @(
                        @{
                            Name  = 'HideLogonBackgroundImage'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$BackgroundPictureMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $LockScreenBackgroundPictureOnSigninScreen
            }
            'GPO'
            {
                # gpo\ not configured: delete (default) | off: 1 (also remove setting from the GUI)
                $LockScreenBackgroundPictureOnSigninScreenGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableLogonBackgroundImage'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$BackgroundPictureMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $LockScreenBackgroundPictureOnSigninScreenGpo
            }
        }
    }
}
