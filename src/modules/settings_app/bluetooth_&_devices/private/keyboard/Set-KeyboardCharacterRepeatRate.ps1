#=================================================================================================================
#                         Bluetooth & Devices > Keyboard > Keyboard Character Repeat Rate
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardCharacterRepeatRate
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-KeyboardCharacterRepeatRate
{
    <#
    .EXAMPLE
        PS> Set-KeyboardCharacterRepeatRate -Value 31
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 31)]
        [int] $Value
    )

    process
    {
        # default: 31 (range 0-31)
        $KeyboardCharacterRepeatRate = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Keyboard'
            Entries = @(
                @{
                    Name  = 'KeyboardSpeed'
                    Value = $Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Character Repeat Rate' to '$Value' ..."
        Set-RegistryEntry -InputObject $KeyboardCharacterRepeatRate
    }
}
