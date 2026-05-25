#=================================================================================================================
#                         Bluetooth & Devices > Keyboard > Keyboard Character Repeat Rate
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardCharacterRepeatRate
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-KeyboardCharacterRepeatRate
{
    <#
    .EXAMPLE
        PS> Set-KeyboardCharacterRepeatRate -Speed 31
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 31)]
        [int] $Speed
    )

    process
    {
        # default: 31 (range: 0-31)
        $KeyboardCharacterRepeatRate = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Keyboard'
            Entries = @(
                @{
                    Name  = 'KeyboardSpeed'
                    Value = $Speed
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Character Repeat Rate' to '$Speed' ..."
        Set-RegistryEntry -InputObject $KeyboardCharacterRepeatRate
    }
}
