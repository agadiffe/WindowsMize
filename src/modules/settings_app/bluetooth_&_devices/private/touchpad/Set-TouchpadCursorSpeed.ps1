#=================================================================================================================
#                                  Bluetooth & Devices > Touchpad > Cursor Speed
#=================================================================================================================

<#
.SYNTAX
    Set-TouchpadCursorSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-TouchpadCursorSpeed
{
    <#
    .EXAMPLE
        PS> Set-TouchpadCursorSpeed -Speed 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 10)]
        [int] $Speed
    )

    process
    {
        # default: 10 (range: 2-20)
        $TouchpadCursorSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'
            Entries = @(
                @{
                    Name  = 'CursorSpeed'
                    Value = $Speed * 2
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad - Cursor Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $TouchpadCursorSpeed
    }
}
