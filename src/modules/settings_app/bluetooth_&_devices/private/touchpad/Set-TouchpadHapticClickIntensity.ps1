#=================================================================================================================
#                             Bluetooth & Devices > Touchpad > Haptic Click Intensity
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadHapticClickIntensity
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-TouchpadHapticClickIntensity
{
    <#
    .EXAMPLE
        PS> Set-TouchpadHapticClickIntensity -Value 50
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 5)]
        [int] $Value
    )

    process
    {
        # GUI values: range 1-5
        $SettingValue = ($Value - 1) * 25

        # default: 50 (range 0-100)
        $TouchpadHapticClickIntensity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'FeedbackIntensity'
                    Value = $SettingValue
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Haptic Click Intensity' to '$SettingValue' ..."
        Set-RegistryEntry -InputObject $TouchpadHapticClickIntensity
    }
}
