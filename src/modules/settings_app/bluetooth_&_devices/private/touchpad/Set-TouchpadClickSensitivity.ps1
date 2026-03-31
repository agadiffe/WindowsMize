#=================================================================================================================
#                               Bluetooth & Devices > Touchpad > Click Sensitivity
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadClickSensitivity
        [-Value] {Light | Medium | Heavy}
        [<CommonParameters>]
#>

function Set-TouchpadClickSensitivity
{
    <#
    .EXAMPLE
        PS> Set-TouchpadClickSensitivity -Value 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadClickSensitivityMode] $Value
    )

    process
    {
        # light: 0 | medium: 50 (default) | heavy: 100
        $TouchpadClickSensitivity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'ClickForceSensitivity'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Click Sensitivity' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadClickSensitivity
    }
}
