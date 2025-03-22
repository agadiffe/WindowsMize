#=================================================================================================================
#                                  Personnalization > Colors > Accent Color Mode
#=================================================================================================================

<#
.SYNTAX
    Set-AccentColorMode
        [-Value] {Manual | Automatic}
        [<CommonParameters>]
#>

function Set-AccentColorMode
{
    <#
    .EXAMPLE
        PS> Set-AccentColorMode -Value 'Manual'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AccentColorMode] $Value
    )

    process
    {
        # manual: 0 | automatic: 1 (default)
        # default manual color: blue (#0078D4)
        $AccentColorMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'AutoColorization'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Colors - Accent Color Mode' to '$Value' ..."
        Set-RegistryEntry -InputObject $AccentColorMode
    }
}
