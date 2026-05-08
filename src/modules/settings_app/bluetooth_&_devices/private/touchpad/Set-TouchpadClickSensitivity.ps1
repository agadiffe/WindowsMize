#=================================================================================================================
#                               Bluetooth & Devices > Touchpad > Click Sensitivity
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadClickSensitivity
        [-Sensitivity] {Light | Medium | Heavy}
        [<CommonParameters>]
#>

function Set-TouchpadClickSensitivity
{
    <#
    .EXAMPLE
        PS> Set-TouchpadClickSensitivity -Sensitivity 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadClickSensitivityMode] $Sensitivity
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
                    Value = [int]$Sensitivity
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Click Sensitivity' to '$Sensitivity' ..."
        Set-RegistryEntry -InputObject $TouchpadClickSensitivity
    }
}
