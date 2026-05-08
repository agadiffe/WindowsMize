#=================================================================================================================
#                             Bluetooth & Devices > Touchpad > Right-Click Zone Size
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadRightClickZoneSize
        [-Size] {Default | Small | Medium | Large}
        [<CommonParameters>]
#>

function Set-TouchpadRightClickZoneSize
{
    <#
    .EXAMPLE
        PS> Set-TouchpadRightClickZoneSize -Size 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadRightClickZoneSize] $Size
    )

    process
    {
        $ZoneWidth, $ZoneHeight = switch ($Size)
        {
            'Default' {  0,  0 }
            'Small'   { 25, 10 }
            'Medium'  { 25, 33 }
            'Large'   { 33, 50 }
        }

        # Default: 0 0 | Small: 25 10 | Medium: 25 33 | Large: 33 50
        $TouchpadRightClickZoneSize = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'RightClickZoneWidth'
                    Value = $ZoneWidth
                    Type  = 'DWord'
                }
                @{
                    Name  = 'RightClickZoneHeight'
                    Value = $ZoneHeight
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Right-Click Zone Size' to '$Size' ..."
        Set-RegistryEntry -InputObject $TouchpadRightClickZoneSize
    }
}
