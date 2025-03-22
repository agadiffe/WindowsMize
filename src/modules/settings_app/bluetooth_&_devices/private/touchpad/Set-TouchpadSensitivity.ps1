#=================================================================================================================
#                          Bluetooth & Devices > Touchpad > Taps > Touchpad Sensitivity
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadSensitivity
        [-Value] {Max | High | Medium | Low}
        [<CommonParameters>]
#>

function Set-TouchpadSensitivity
{
    <#
    .EXAMPLE
        PS> Set-TouchpadSensitivity -Value 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadSensitivityMode] $Value
    )

    process
    {
        # most sensitive: 0 | high sensitivity: 1 | medium sensitivity: 2 (default) | low sensitivity: 3
        $TouchpadSensitivity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad\Status'
            Entries = @(
                @{
                    Name  = 'AAPThreshold'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad Sensitivity' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadSensitivity
    }
}
