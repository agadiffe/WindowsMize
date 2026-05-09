#=================================================================================================================
#                          Bluetooth & Devices > Touchpad > Scroll & Zoom > Scroll Speed
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadScrollSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-TouchpadScrollSpeed
{
    <#
    .EXAMPLE
        PS> Set-TouchpadScrollSpeed -Speed 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 10)]
        [int] $Speed
    )

    process
    {
        # default: 50 (range 0-100)
        $TouchpadScrollSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'PanSensitivity'
                    Value = $Speed * 10
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Scroll Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $TouchpadScrollSpeed
    }
}
