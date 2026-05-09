#=================================================================================================================
#                  Bluetooth & Devices > Touchpad > Scroll & Zoom > Automatic Scrolling At Edge
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadAutoScrollingAtEdge
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TouchpadAutoScrollingAtEdge
{
    <#
    .EXAMPLE
        PS> Set-TouchpadAutoScrollingAtEdge -State 'Enabled'
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
        $EdgeAutoScrolling = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'EdgeAutoPanningEnabled'
                    Value = $State -eq 'Enabled' ? [uint]::MaxValue : 0
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Automatic Scrolling At Edge' to '$State' ..."
        Set-RegistryEntry -InputObject $EdgeAutoScrolling
    }
}
