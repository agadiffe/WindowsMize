#=================================================================================================================
#                    Privacy & Security > App Permissions > Location > Allow Location Override
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsLocationAllowOverride
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsLocationAllowOverride
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsLocationAllowOverride -State 'Disabled'
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
        $LocationAllowOverride = [AppPermissionSetting]::new(@{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CPSS\Store\UserLocationOverridePrivacySetting'
            Entries = @(
                @{
                    Name  = 'Value'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        })

        $LocationAllowOverride.WriteVerboseMsg('Location: Allow Location Override', $State)
        $LocationAllowOverride.SetRegistryEntry()
    }
}
