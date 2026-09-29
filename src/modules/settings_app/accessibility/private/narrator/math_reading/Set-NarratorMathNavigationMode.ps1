#=================================================================================================================
#                            Accessibility > Narrator > Math Reading > Navigation Mode
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathNavigationMode
        [-Mode] {Enhanced | Simple | Character}
        [<CommonParameters>]
#>

function Set-NarratorMathNavigationMode
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathNavigationMode -Mode 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MathNavigationMode] $Mode
    )

    process
    {
        # EnhancedMode (default) | SimpleMode | CharacterMode
        $NarratorMathNavigationMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathNavigationMode'
                    Value = $Mode + 'Mode'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Navigation Mode' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorMathNavigationMode
    }
}
