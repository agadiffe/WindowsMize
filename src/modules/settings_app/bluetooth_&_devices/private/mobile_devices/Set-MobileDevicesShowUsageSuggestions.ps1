#=================================================================================================================
#       Bluetooth & Devices > Mobile Devices > Show Me Suggestions For Using My Mobile Device With Windows
#=================================================================================================================

<#
.SYNTAX
    Set-MobileDevicesShowUsageSuggestions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MobileDevicesShowUsageSuggestions
{
    <#
    .EXAMPLE
        PS> Set-MobileDevicesShowUsageSuggestions -State 'Disabled'
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
        $MobileDevicesUsageSuggestions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Mobility'
            Entries = @(
                @{
                    Name  = 'OptedIn'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mobile Devices - Show Me Suggestions For Using My Mobile Device With Windows' to '$State' ..."
        Set-RegistryEntry -InputObject $MobileDevicesUsageSuggestions
    }
}
