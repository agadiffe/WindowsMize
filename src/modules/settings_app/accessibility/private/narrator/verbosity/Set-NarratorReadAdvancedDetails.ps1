#=================================================================================================================
#                       Accessibility > Narrator > Verbosity Level > Read Advanced Details
#=================================================================================================================

# Read advanced details, like help text, on buttons and other controls.

<#
.SYNTAX
    Set-NarratorReadAdvancedDetails
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorReadAdvancedDetails
{
    <#
    .EXAMPLE
        PS> Set-NarratorReadAdvancedDetails -State 'Disabled'
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
        $NarratorReadAdvancedDetails = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'AutoreadAdvancedInfo'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Verbosity Level: Read Advanced Details' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorReadAdvancedDetails
    }
}
