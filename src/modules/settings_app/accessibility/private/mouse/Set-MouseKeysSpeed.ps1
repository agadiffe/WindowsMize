#=================================================================================================================
#                                    Accessibility > Mouse > Mouse Keys Speed
#=================================================================================================================

<#
.SYNTAX
    Set-MouseKeysSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-MouseKeysSpeed
{
    <#
    .EXAMPLE
        PS> Set-MouseKeysSpeed -Speed 21
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Speed
    )

    process
    {
        # GUI slider range is 1 to 100, but have 2 times the 1 & 100 value.
        # The slider takes into account only pair number.
        # e.g. if 42 is selected: reg value is 154. Use the arrow to select 41 or 43, the reg value is still 154.
        # first 1 is 10, second 1 is ignored. first 100 is 357, second 100 is 358.
        # lol ?

        # Normalize from one range to another
        # newValue = newMin + ( (value - oldMin) * (newMax - newMin) / (oldMax - oldMin) )

        # stay as close as possible to the Windows values
        $Value = $Speed -eq 100 ? 358 : [Math]::Round(10 + $Speed * 3.5, [MidpointRounding]::AwayFromZero)

        # default: 84 (range: 10-358)
        $MouseKeysSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\MouseKeys'
            Entries = @(
                @{
                    Name  = 'MaximumSpeed'
                    Value = $Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse Keys Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $MouseKeysSpeed
    }
}
