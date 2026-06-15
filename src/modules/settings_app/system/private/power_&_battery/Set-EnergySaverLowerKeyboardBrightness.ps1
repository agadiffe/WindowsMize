#=================================================================================================================
#                       System > Power & Battery > Energy Saver > Lower Keyboard Brightness
#=================================================================================================================

# Keyboard backlight brightness percentage :
#   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Lighting\Backlight​
#   BacklightEnergySaverMultiplier DWord
#   Value: 0 (no brightness) to 100 (no dimming)

<#
.SYNTAX
    Set-EnergySaverLowerKeyboardBrightness
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-EnergySaverLowerKeyboardBrightness
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverLowerKeyboardBrightness -State 'Disabled'
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
        $LowerKeyboardBrightness = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Lighting\Backlight'
            Entries = @(
                @{
                    Name  = 'BacklightEnergySaverEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Energy Saver - Lower Keyboard Brightness' to '$State' ..."
        Set-RegistryEntry -InputObject $LowerKeyboardBrightness
    }
}
