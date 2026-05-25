#=================================================================================================================
#                             Bluetooth & Devices > Touchpad > Haptic Click Intensity
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadHapticFeedbackIntensity
        [-Intensity] <int>
        [<CommonParameters>]
#>

function Set-TouchpadHapticFeedbackIntensity
{
    <#
    .EXAMPLE
        PS> Set-TouchpadHapticFeedbackIntensity -Intensity 3
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 5)]
        [int] $Intensity
    )

    process
    {
        # default: 50 (range: 0-100)
        $TouchpadHapticFeedbackIntensity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'FeedbackIntensity'
                    Value = ($Intensity - 1) * 25
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Haptic Click Intensity' to '$Intensity' ..."
        Set-RegistryEntry -InputObject $TouchpadHapticFeedbackIntensity
    }
}
