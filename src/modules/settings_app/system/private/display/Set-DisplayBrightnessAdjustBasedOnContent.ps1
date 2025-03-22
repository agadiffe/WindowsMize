#=================================================================================================================
#                       System > Display > Brightness > Change Brightness Based On Content
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayBrightnessAdjustBasedOnContent
        [-State] {Disabled | Enabled | BatteryOnly}
        [<CommonParameters>]
#>

function Set-DisplayBrightnessAdjustBasedOnContent
{
    <#
    .DESCRIPTION
        Available with a built-in display (e.g. Laptop).

    .EXAMPLE
        PS> Set-DisplayBrightnessAdjustBasedOnContent -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [BrightnessContentState] $State
    )

    process
    {
        # off: 0 | always: 1 | on battery only: 2 (default)
        $BrightnessBasedOnContent = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\GraphicsDrivers'
            Entries = @(
                @{
                    Name  = 'CABCOption'
                    Value = [int]$State
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Display - Change Brightness Based On Content' to '$State' ..."
        Set-RegistryEntry -InputObject $BrightnessBasedOnContent
    }
}
