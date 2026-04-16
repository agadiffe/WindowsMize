#=================================================================================================================
#                           Gaming > Game Bar > Use View + Menu as Guide Button In Apps
#=================================================================================================================

<#
.SYNTAX
    Set-GameBarUseViewMenuAsGuideButtonInApps
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-GameBarUseViewMenuAsGuideButtonInApps
{
    <#
    .EXAMPLE
        PS> Set-GameBarUseViewMenuAsGuideButtonInApps -State 'Disabled'
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
        $GameBarUseViewMenuAsGuideButtonInApps = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\GameBar'
            Entries = @(
                @{
                    Name  = 'GamepadNexusChordEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Game Bar - Use View + Menu as Guide Button In Apps' to '$State' ..."
        Set-RegistryEntry -InputObject $GameBarUseViewMenuAsGuideButtonInApps
    }
}
