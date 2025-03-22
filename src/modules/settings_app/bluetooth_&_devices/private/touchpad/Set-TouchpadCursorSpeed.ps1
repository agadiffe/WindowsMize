#=================================================================================================================
#                                  Bluetooth & Devices > Touchpad > Cursor Speed
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadCursorSpeed
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-TouchpadCursorSpeed
{
    <#
    .EXAMPLE
        PS> Set-TouchpadCursorSpeed -Value 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 10)]
        [int] $Value
    )

    process
    {
        # GUI values are divided by 2
        $SettingValue = $Value * 2

        # default: 10 (range 2-20)
        $TouchpadCursorSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'CursorSpeed'
                    Value = [string]$SettingValue
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Cursor Speed' to '$SettingValue' ..."
        Set-RegistryEntry -InputObject $TouchpadCursorSpeed
    }
}
