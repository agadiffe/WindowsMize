#=================================================================================================================
#                        Bluetooth & Devices > Keyboard > Keyboard Character Repeat Delay
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardCharacterRepeatDelay
        [-Delay] <int>
        [<CommonParameters>]
#>

function Set-KeyboardCharacterRepeatDelay
{
    <#
    .EXAMPLE
        PS> Set-KeyboardCharacterRepeatDelay -Delay 1
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 3)]
        [int] $Delay
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
                    Value = $Delay
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Character Repeat Delay' to '$Delay' ..."
        Set-RegistryEntry -InputObject $KeyboardCharacterRepeatDelay
    }
}
