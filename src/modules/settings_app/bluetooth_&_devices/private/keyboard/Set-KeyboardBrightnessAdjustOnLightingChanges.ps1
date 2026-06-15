#=================================================================================================================
#         Bluetooth & Devices > Keyboard > Change Keyboard Brightness Automatically When Lighting Changes
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardBrightnessAdjustOnLightingChanges
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-KeyboardBrightnessAdjustOnLightingChanges
{
    <#
    .EXAMPLE
        PS> Set-KeyboardBrightnessAdjustOnLightingChanges -State 'Enabled'
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
        $KeyboardBrightnessAdjustOnLightingChanges = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Lighting\Backlight'
            Entries = @(
                @{
                    Name  = 'EnableBucketedBacklightAutobrightness'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Change Keyboard Brightness Automatically When Lighting Changes' to '$State' ..."
        Set-RegistryEntry -InputObject $KeyboardBrightnessAdjustOnLightingChanges
    }
}
