#=================================================================================================================
#                 Personnalization > Colors > Show Accent Color On Title Bars And Window Borders
#=================================================================================================================

<#
.SYNTAX
    Set-AccentColorShowOnTitleAndBorders
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AccentColorShowOnTitleAndBorders
{
    <#
    .EXAMPLE
        PS> Set-AccentColorShowOnTitleAndBorders -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $AccentColorOnTitleAndBorders = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\DWM'
            Entries = @(
                @{
                    Name  = 'ColorPrevalence'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Colors - Show Accent Color On Title Bars And Windows Borders' to '$State' ..."
        Set-RegistryEntry -InputObject $AccentColorOnTitleAndBorders
    }
}
