#=================================================================================================================
#                        Bluetooth & Devices > Keyboard > Keyboard Character Repeat Delay
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardCharacterRepeatDelay
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-KeyboardCharacterRepeatDelay
{
    <#
    .EXAMPLE
        PS> Set-KeyboardCharacterRepeatDelay -Value 1
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 3)]
        [int] $Value
    )

    process
    {
        # default: 1 (range 0-3)
        $KeyboardCharacterRepeatDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Keyboard'
            Entries = @(
                @{
                    Name  = 'KeyboardDelay'
                    Value = $Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Character Repeat Delay' to '$Value' ..."
        Set-RegistryEntry -InputObject $KeyboardCharacterRepeatDelay
    }
}
