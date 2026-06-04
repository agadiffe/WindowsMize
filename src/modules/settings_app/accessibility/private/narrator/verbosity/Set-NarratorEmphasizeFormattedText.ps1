#=================================================================================================================
#                      Accessibility > Narrator > Verbosity Level > Emphasize Formatted Text
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorEmphasizeFormattedText
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorEmphasizeFormattedText
{
    <#
    .EXAMPLE
        PS> Set-NarratorEmphasizeFormattedText -State 'Disabled'
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
        $NarratorEmphasizeFormattedText = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'ReadingWithIntent'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Verbosity Level: Emphasize Formatted Text' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorEmphasizeFormattedText
    }
}
