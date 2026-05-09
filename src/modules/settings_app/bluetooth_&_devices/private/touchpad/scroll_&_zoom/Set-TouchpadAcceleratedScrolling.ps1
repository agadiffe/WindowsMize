#=================================================================================================================
#                    Bluetooth & Devices > Touchpad > Scroll & Zoom > Accelerated Scrolling
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadAcceleratedScrolling
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadAcceleratedScrolling
{
    <#
    .EXAMPLE
        PS> Set-TouchpadAcceleratedScrolling -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 4294967295 (UINT_MAX) (default) | off: 0
        $AcceleratedScrolling = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'BoostedPanningEnabled'
                    Value = $State -eq 'Enabled' ? [uint]::MaxValue : 0
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Accelerated Scrolling' to '$State' ..."
        Set-RegistryEntry -InputObject $AcceleratedScrolling
    }
}
