#=================================================================================================================
#               Privacy & Security > App Permissions > Location > Notify When Apps Request Location
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsLocationAppsRequestNotif
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsLocationAppsRequestNotif
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsLocationAppsRequestNotif -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $LocationAppsRequestNotif = [AppPermissionSetting]::new(@{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location'
            Entries = @(
                @{
                    Name  = 'ShowGlobalPrompts'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        })

        $LocationAppsRequestNotif.WriteVerboseMsg('Location: Notify When Apps Request Location', $State)
        $LocationAppsRequestNotif.SetRegistryEntry()
    }
}
