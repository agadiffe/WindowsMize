#=================================================================================================================
#                                  Personnalization > Colors > Accent Color Mode
#=================================================================================================================

<#
.SYNTAX
    Set-AccentColorMode
        [-Mode] {Manual | Automatic}
        [<CommonParameters>]
#>

function Set-AccentColorMode
{
    <#
    .EXAMPLE
        PS> Set-AccentColorMode -Mode 'Manual'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AccentColorMode] $Mode
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
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Colors - Accent Color Mode' to '$Mode' ..."
        Set-RegistryEntry -InputObject $AccentColorMode
    }
}
