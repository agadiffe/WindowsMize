#=================================================================================================================
#                                Accessibility > Mouse Pointer > Pointer Indicator
#=================================================================================================================

<#
.SYNTAX
    Set-MousePointerIndicatorCrosshair
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MousePointerIndicatorCrosshair
{
    <#
    .EXAMPLE
        PS> Set-MousePointerIndicatorCrosshair -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $MousePointerIndicatorCrosshair = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Cursors'
            Entries = @(
                @{
                    Name  = 'CursorCrosshairEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse Pointer - Pointer Indicator (Crosshair)' to '$State' ..."
        Set-RegistryEntry -InputObject $MousePointerIndicatorCrosshair
    }
}
