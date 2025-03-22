#=================================================================================================================
#                                          Telemetry - User Info Sharing
#=================================================================================================================

# By disabling this setting, apps (excluding desktop apps) are restricted from accessing sensitive user information.
# This prevents unintended sharing of personal or organizational data with applications that may not require it.

<#
.SYNTAX
    Set-UserInfoSharing
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-UserInfoSharing
{
    <#
    .EXAMPLE
        PS> Set-UserInfoSharing -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > system > user profiles
        #   user management of sharing user name, account picture, and domain information with apps (not desktop apps)
        # not configured: delete (default) | on: always on (1), always off (2)
        $UserInfoSharingGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowUserInfoAccess'
                    Value = $GPO -eq 'Enabled' ? '1' : '2'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'User Info Sharing (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $UserInfoSharingGpo
    }
}
