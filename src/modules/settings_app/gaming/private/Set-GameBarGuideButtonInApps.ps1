#=================================================================================================================
#                                  Gaming > Game Bar > Use Guide Button In Apps
#=================================================================================================================

<#
.SYNTAX
    Set-GameBarGuideButtonInApps
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-GameBarGuideButtonInApps
{
    <#
    .EXAMPLE
        PS> Set-GameBarGuideButtonInApps -State 'Disabled'
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
        $GameBarGuideButtonInApps = @{
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

        Write-Verbose -Message "Setting 'Game Bar - Use Guide Button In Apps' to '$State' ..."
        Set-RegistryEntry -InputObject $GameBarGuideButtonInApps
    }
}
