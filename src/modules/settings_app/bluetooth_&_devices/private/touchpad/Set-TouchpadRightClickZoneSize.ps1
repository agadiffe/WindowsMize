#=================================================================================================================
#                             Bluetooth & Devices > Touchpad > Right-Click Zone Size
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadRightClickZoneSize
        [-Value] {Default | Small | Medium | Large}
        [<CommonParameters>]
#>

function Set-TouchpadRightClickZoneSize
{
    <#
    .EXAMPLE
        PS> Set-TouchpadRightClickZoneSize -Value 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchpadRightClickZoneSize] $Value
    )

    process
    {
        $ZoneWidth, $ZoneHeight = switch ($Value)
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

        Write-Verbose -Message "Setting 'Touchpad - Right-Click Zone Size' to '$Value' ..."
        Set-RegistryEntry -InputObject $TouchpadRightClickZoneSize
    }
}
