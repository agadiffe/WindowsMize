#=================================================================================================================
#                             Bluetooth & Devices > Mouse > Haptic Signals Intensity
#=================================================================================================================

<#
.SYNTAX
    Set-MouseHapticFeedbackIntensity
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-MouseHapticFeedbackIntensity
{
    <#
    .EXAMPLE
        PS> Set-MouseHapticFeedbackIntensity -Value 2
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 4)]
        [int] $Value
    )

    process
    {
        $SettingValue = switch ($Value)
        {
            '1' { '0 0 0 0 0 0 208 63' }
            '2' { '0 0 0 0 0 0 224 63' }
            '3' { '0 0 0 0 0 0 232 63' }
            '4' { '0 0 0 0 0 0 240 63' }
        }

        # default: 2 (range 1-4)
        $MouseHapticFeedbackIntensity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Windows\EnhancedPenSupport'
            Entries = @(
                @{
                    Name  = 'MouseFeedbackIntensity'
                    Value = $SettingValue
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Haptic Signals Intensity' to '$Value' ..."
        Set-RegistryEntry -InputObject $MouseHapticFeedbackIntensity
    }
}
