#=================================================================================================================
#                          Personnalization > Lock Screen > Personalize Your Lock Screen
#=================================================================================================================

# Default: Windows spotlight

# The selection of the picture is not handled.
# Default images location: C:\Windows\Web\Screen

<#
.SYNTAX
    Set-LockScreenToPicture [<CommonParameters>]
#>

function Set-LockScreenToPicture
{
    [CmdletBinding()]
    param ()

    process
    {
        $UserSid = Get-LoggedOnUserSID

        $LockScreenSetToPicture = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Control Panel\Desktop'
                Entries = @(
                    @{
                        Name  = 'LockScreenAutoLockActive'
                        Value = '0'
                        Type  = 'String'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Lock Screen'
                Entries = @(
                    @{
                        Name  = 'SlideshowEnabled'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
                Entries = @(
                    @{
                        Name  = 'RotatingLockScreenEnabled'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\$UserSid"
                Entries = @(
                    @{
                        Name  = 'RotatingLockScreenEnabled'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Lock Screen - Personalize Your Lock Screen' to 'Picture' ..."
        $LockScreenSetToPicture | Set-RegistryEntry
    }
}
