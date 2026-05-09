#=================================================================================================================
#                          Bluetooth & Devices > Touchpad > Taps > Touchpad Sensitivity
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadSensitivity
        [-Sensitivity] {Max | High | Medium | Low}
        [<CommonParameters>]
#>

function Set-TouchpadSensitivity
{
    <#
    .EXAMPLE
        PS> Set-TouchpadSensitivity -Sensitivity 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadSensitivityMode] $Sensitivity
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
                    Value = [int]$Sensitivity
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad Sensitivity' to '$Sensitivity' ..."
        Set-RegistryEntry -InputObject $TouchpadSensitivity
    }
}
